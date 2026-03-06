/**
 * @file matnm.c3
 * @brief Arbitrary NxM matrix type with heap-allocated storage
 * @module mathlib::matnm
 */

module mathlib::matnm;

import mathlib::core;
import mathlib::matrix;
import mathlib::power;
import std::io;
import std::math;

struct MatNM {
    usz rows;
    usz cols;
    double[] data;  // heap-allocated, column-major, size = rows * cols
}

// ============================================================================
// Constructors & Destructor
// ============================================================================

fn MatNM matnm_new(usz rows, usz cols) {
    usz size = rows * cols;
    double[] data = mem::new_array(double, size);
    for (usz i = 0; i < size; i++) {
        data[i] = 0.0;
    }
    MatNM m;
    m.rows = rows;
    m.cols = cols;
    m.data = data;
    return m;
}

fn MatNM matnm_identity(usz n) {
    MatNM m = matnm_new(n, n);
    for (usz i = 0; i < n; i++) {
        m.data[i * n + i] = 1.0;
    }
    return m;
}

fn MatNM matnm_from_data(usz rows, usz cols, double[] src) {
    usz size = rows * cols;
    double[] data = mem::new_array(double, size);
    for (usz i = 0; i < size; i++) {
        data[i] = src[i];
    }
    MatNM m;
    m.rows = rows;
    m.cols = cols;
    m.data = data;
    return m;
}

fn void matnm_free(MatNM* m) {
    if (m.data.len > 0) {
        mem::free(m.data);
        m.data = {};
        m.rows = 0;
        m.cols = 0;
    }
}

// ============================================================================
// Element Access
// ============================================================================

fn double MatNM.get(&self, usz row, usz col) {
    return self.data[col * self.rows + row];
}

fn void MatNM.set(&self, usz row, usz col, double val) {
    self.data[col * self.rows + row] = val;
}

fn double[] MatNM.get_row(&self, usz row) {
    double[] result = mem::new_array(double, self.cols);
    for (usz c = 0; c < self.cols; c++) {
        result[c] = self.data[c * self.rows + row];
    }
    return result;
}

fn double[] MatNM.get_col(&self, usz col) {
    double[] result = mem::new_array(double, self.rows);
    for (usz r = 0; r < self.rows; r++) {
        result[r] = self.data[col * self.rows + r];
    }
    return result;
}

// ============================================================================
// Arithmetic
// ============================================================================

fn MatNM MatNM.add(MatNM a, MatNM b) @operator(+) {
    MatNM result = matnm_new(a.rows, a.cols);
    for (usz i = 0; i < a.data.len; i++) {
        result.data[i] = a.data[i] + b.data[i];
    }
    return result;
}

fn MatNM MatNM.sub(MatNM a, MatNM b) @operator(-) {
    MatNM result = matnm_new(a.rows, a.cols);
    for (usz i = 0; i < a.data.len; i++) {
        result.data[i] = a.data[i] - b.data[i];
    }
    return result;
}

fn MatNM MatNM.neg(MatNM a) @operator(-) {
    MatNM result = matnm_new(a.rows, a.cols);
    for (usz i = 0; i < a.data.len; i++) {
        result.data[i] = -a.data[i];
    }
    return result;
}

fn MatNM MatNM.mul(MatNM a, MatNM b) @operator(*) {
    // NxM * MxP = NxP
    MatNM result = matnm_new(a.rows, b.cols);
    for (usz col = 0; col < b.cols; col++) {
        for (usz row = 0; row < a.rows; row++) {
            double sum = 0;
            for (usz k = 0; k < a.cols; k++) {
                sum += a.data[k * a.rows + row] * b.data[col * b.rows + k];
            }
            result.data[col * result.rows + row] = sum;
        }
    }
    return result;
}

fn MatNM MatNM.scale(MatNM a, double s) {
    MatNM result = matnm_new(a.rows, a.cols);
    for (usz i = 0; i < a.data.len; i++) {
        result.data[i] = a.data[i] * s;
    }
    return result;
}

fn MatNM MatNM.pow(MatNM a, double exp) @operator(^) {
    MatNM result = matnm_new(a.rows, a.cols);
    for (usz i = 0; i < a.data.len; i++) {
        result.data[i] = power::pow(a.data[i], exp);
    }
    return result;
}

// ============================================================================
// Matrix Operations
// ============================================================================

fn MatNM MatNM.transpose(&self) {
    MatNM result = matnm_new(self.cols, self.rows);
    for (usz col = 0; col < self.cols; col++) {
        for (usz row = 0; row < self.rows; row++) {
            result.data[row * result.rows + col] = self.data[col * self.rows + row];
        }
    }
    return result;
}

fn double MatNM.trace(&self) {
    usz n = self.rows < self.cols ? self.rows : self.cols;
    double sum = 0;
    for (usz i = 0; i < n; i++) {
        sum += self.data[i * self.rows + i];
    }
    return sum;
}

fn double MatNM.frobenius_norm(&self) {
    double sum = 0;
    for (usz i = 0; i < self.data.len; i++) {
        sum += self.data[i] * self.data[i];
    }
    return math::sqrt(sum);
}

// ============================================================================
// LU Decomposition (with partial pivoting)
// ============================================================================

struct LUResult {
    MatNM l;
    MatNM u;
    int sign;  // determinant sign from pivoting
}

fn LUResult MatNM.lu_decompose(&self) {
    usz n = self.rows;
    MatNM l = matnm_identity(n);
    MatNM u = matnm_new(n, n);
    // Copy self into u
    for (usz i = 0; i < self.data.len; i++) {
        u.data[i] = self.data[i];
    }

    int sign = 1;

    for (usz k = 0; k < n; k++) {
        // Find pivot
        double max_val = core::abs(u.get(k, k));
        usz max_row = k;
        for (usz i = k + 1; i < n; i++) {
            double val = core::abs(u.get(i, k));
            if (val > max_val) {
                max_val = val;
                max_row = i;
            }
        }

        // Swap rows in u
        if (max_row != k) {
            for (usz j = 0; j < n; j++) {
                double tmp = u.get(k, j);
                u.set(k, j, u.get(max_row, j));
                u.set(max_row, j, tmp);
            }
            // Swap corresponding entries in l (below diagonal)
            for (usz j = 0; j < k; j++) {
                double tmp = l.get(k, j);
                l.set(k, j, l.get(max_row, j));
                l.set(max_row, j, tmp);
            }
            sign = -sign;
        }

        double pivot = u.get(k, k);
        if (core::abs(pivot) < core::EPSILON) {
            continue;
        }

        for (usz i = k + 1; i < n; i++) {
            double factor = u.get(i, k) / pivot;
            l.set(i, k, factor);
            for (usz j = k; j < n; j++) {
                u.set(i, j, u.get(i, j) - factor * u.get(k, j));
            }
        }
    }

    LUResult result;
    result.l = l;
    result.u = u;
    result.sign = sign;
    return result;
}

fn double MatNM.determinant(&self) {
    usz n = self.rows;
    if (n == 1) {
        return self.data[0];
    }
    if (n == 2) {
        return self.get(0, 0) * self.get(1, 1) - self.get(0, 1) * self.get(1, 0);
    }

    LUResult lu = self.lu_decompose();
    double det = (double)lu.sign;
    for (usz i = 0; i < n; i++) {
        det *= lu.u.get(i, i);
    }
    matnm_free(&lu.l);
    matnm_free(&lu.u);
    return det;
}

// ============================================================================
// Inverse via Gaussian Elimination
// ============================================================================

fn MatNM MatNM.inverse(&self) {
    usz n = self.rows;
    // Build augmented matrix [self | I]
    MatNM aug = matnm_new(n, 2 * n);
    for (usz col = 0; col < n; col++) {
        for (usz row = 0; row < n; row++) {
            aug.set(row, col, self.get(row, col));
        }
    }
    for (usz i = 0; i < n; i++) {
        aug.set(i, n + i, 1.0);
    }

    // Forward elimination with partial pivoting
    for (usz k = 0; k < n; k++) {
        // Find pivot
        double max_val = core::abs(aug.get(k, k));
        usz max_row = k;
        for (usz i = k + 1; i < n; i++) {
            double val = core::abs(aug.get(i, k));
            if (val > max_val) {
                max_val = val;
                max_row = i;
            }
        }

        // Swap rows
        if (max_row != k) {
            for (usz j = 0; j < 2 * n; j++) {
                double tmp = aug.get(k, j);
                aug.set(k, j, aug.get(max_row, j));
                aug.set(max_row, j, tmp);
            }
        }

        double pivot = aug.get(k, k);
        if (core::abs(pivot) < core::EPSILON) {
            // Singular matrix - return identity as fallback
            matnm_free(&aug);
            return matnm_identity(n);
        }

        // Scale pivot row
        for (usz j = 0; j < 2 * n; j++) {
            aug.set(k, j, aug.get(k, j) / pivot);
        }

        // Eliminate column
        for (usz i = 0; i < n; i++) {
            if (i == k) continue;
            double factor = aug.get(i, k);
            for (usz j = 0; j < 2 * n; j++) {
                aug.set(i, j, aug.get(i, j) - factor * aug.get(k, j));
            }
        }
    }

    // Extract inverse from augmented matrix
    MatNM result = matnm_new(n, n);
    for (usz col = 0; col < n; col++) {
        for (usz row = 0; row < n; row++) {
            result.set(row, col, aug.get(row, n + col));
        }
    }
    matnm_free(&aug);
    return result;
}

// ============================================================================
// Row Echelon Form & Rank
// ============================================================================

fn MatNM MatNM.row_echelon(&self) {
    MatNM result = matnm_new(self.rows, self.cols);
    for (usz i = 0; i < self.data.len; i++) {
        result.data[i] = self.data[i];
    }

    usz pivot_row = 0;
    for (usz col = 0; col < result.cols && pivot_row < result.rows; col++) {
        // Find pivot in this column
        double max_val = core::abs(result.get(pivot_row, col));
        usz max_row = pivot_row;
        for (usz i = pivot_row + 1; i < result.rows; i++) {
            double val = core::abs(result.get(i, col));
            if (val > max_val) {
                max_val = val;
                max_row = i;
            }
        }

        if (max_val < core::EPSILON) {
            continue;
        }

        // Swap rows
        if (max_row != pivot_row) {
            for (usz j = 0; j < result.cols; j++) {
                double tmp = result.get(pivot_row, j);
                result.set(pivot_row, j, result.get(max_row, j));
                result.set(max_row, j, tmp);
            }
        }

        // Scale pivot row
        double pivot = result.get(pivot_row, col);
        for (usz j = col; j < result.cols; j++) {
            result.set(pivot_row, j, result.get(pivot_row, j) / pivot);
        }

        // Eliminate below and above
        for (usz i = 0; i < result.rows; i++) {
            if (i == pivot_row) continue;
            double factor = result.get(i, col);
            if (core::abs(factor) < core::EPSILON) continue;
            for (usz j = col; j < result.cols; j++) {
                result.set(i, j, result.get(i, j) - factor * result.get(pivot_row, j));
            }
        }

        pivot_row++;
    }

    return result;
}

fn usz MatNM.rank(&self) {
    MatNM ref = self.row_echelon();
    usz r = 0;
    for (usz i = 0; i < ref.rows; i++) {
        bool non_zero = false;
        for (usz j = 0; j < ref.cols; j++) {
            if (core::abs(ref.get(i, j)) > core::EPSILON) {
                non_zero = true;
                break;
            }
        }
        if (non_zero) r++;
    }
    matnm_free(&ref);
    return r;
}

// ============================================================================
// Solve Ax = b via LU Decomposition
// ============================================================================

fn MatNM matnm_solve(MatNM a, MatNM b) {
    usz n = a.rows;
    // Compute inverse and multiply: x = A^{-1} * b
    MatNM inv = a.inverse();
    MatNM result = MatNM.mul(inv, b);
    matnm_free(&inv);
    return result;
}

// ============================================================================
// Conversion from fixed-size matrices
// ============================================================================

fn MatNM matnm_from_mat2(Mat2 m) {
    MatNM result = matnm_new(2, 2);
    for (usz i = 0; i < 4; i++) {
        result.data[i] = m.m[i];
    }
    return result;
}

fn MatNM matnm_from_mat3(Mat3 m) {
    MatNM result = matnm_new(3, 3);
    for (usz i = 0; i < 9; i++) {
        result.data[i] = m.m[i];
    }
    return result;
}

fn MatNM matnm_from_mat4(Mat4 m) {
    MatNM result = matnm_new(4, 4);
    for (usz i = 0; i < 16; i++) {
        result.data[i] = m.m[i];
    }
    return result;
}

// ============================================================================
// Conversion to fixed-size matrices
// ============================================================================

fn Mat2 matnm_to_mat2(MatNM m) {
    Mat2 result;
    for (usz i = 0; i < 4; i++) {
        result.m[i] = m.data[i];
    }
    return result;
}

fn Mat3 matnm_to_mat3(MatNM m) {
    Mat3 result;
    for (usz i = 0; i < 9; i++) {
        result.m[i] = m.data[i];
    }
    return result;
}

fn Mat4 matnm_to_mat4(MatNM m) {
    Mat4 result;
    for (usz i = 0; i < 16; i++) {
        result.m[i] = m.data[i];
    }
    return result;
}
