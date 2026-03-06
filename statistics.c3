/**
 * @file statistics.c3
 * @brief Statistical functions
 * @module mathlib::stats
 */

module mathlib::stats;

import mathlib::core;
import mathlib::power;

/**
 * Calculate the mean (average) of an array
 */
fn double mean(double[] values)
{
    if (values.len == 0) return 0.0;

    double sum = 0.0;
    foreach (val : values) {
        sum += val;
    }
    return sum / (double)values.len;
}

/**
 * Calculate the median of an array
 * Note: This modifies the input array by sorting it
 */
fn double median(double[] values)
{
    if (values.len == 0) return 0.0;

    // Simple bubble sort (could be improved with quicksort)
    for (usz i = 0; i < values.len - 1; i++) {
        for (usz j = 0; j < values.len - i - 1; j++) {
            if (values[j] > values[j + 1]) {
                double temp = values[j];
                values[j] = values[j + 1];
                values[j + 1] = temp;
            }
        }
    }

    usz mid = values.len / 2;
    if (values.len % 2 == 0) {
        return (values[mid - 1] + values[mid]) / 2.0;
    }
    return values[mid];
}

/**
 * Calculate the variance of an array
 */
fn double variance(double[] values)
{
    if (values.len == 0) return 0.0;

    double avg = mean(values);
    double sum = 0.0;

    foreach (val : values) {
        double diff = val - avg;
        sum += diff * diff;
    }

    return sum / (double)values.len;
}

/**
 * Calculate the sample variance (using n-1)
 */
fn double sample_variance(double[] values)
{
    if (values.len <= 1) return 0.0;

    double avg = mean(values);
    double sum = 0.0;

    foreach (val : values) {
        double diff = val - avg;
        sum += diff * diff;
    }

    return sum / (double)(values.len - 1);
}

/**
 * Calculate the standard deviation
 */
fn double std_dev(double[] values)
{
    return power::sqrt(variance(values));
}

/**
 * Calculate the sample standard deviation
 */
fn double sample_std_dev(double[] values)
{
    return power::sqrt(sample_variance(values));
}

/**
 * Find the minimum value in an array
 */
fn double min_value(double[] values)
{
    if (values.len == 0) return 0.0;

    double min_val = values[0];
    foreach (val : values) {
        if (val < min_val) min_val = val;
    }
    return min_val;
}

/**
 * Find the maximum value in an array
 */
fn double max_value(double[] values)
{
    if (values.len == 0) return 0.0;

    double max_val = values[0];
    foreach (val : values) {
        if (val > max_val) max_val = val;
    }
    return max_val;
}

/**
 * Calculate the sum of all values
 */
fn double sum(double[] values)
{
    double total = 0.0;
    foreach (val : values) {
        total += val;
    }
    return total;
}

/**
 * Calculate the product of all values
 */
fn double product(double[] values)
{
    if (values.len == 0) return 0.0;

    double prod = 1.0;
    foreach (val : values) {
        prod *= val;
    }
    return prod;
}

/**
 * Calculate covariance between two arrays
 */
fn double covariance(double[] x, double[] y)
{
    if (x.len != y.len || x.len == 0) return 0.0;

    double mean_x = mean(x);
    double mean_y = mean(y);
    double sum_cov = 0.0;

    for (usz i = 0; i < x.len; i++) {
        sum_cov += (x[i] - mean_x) * (y[i] - mean_y);
    }

    return sum_cov / (double)x.len;
}

/**
 * Calculate Pearson correlation coefficient
 */
fn double correlation(double[] x, double[] y)
{
    if (x.len != y.len || x.len == 0) return 0.0;

    double cov = covariance(x, y);
    double std_x = std_dev(x);
    double std_y = std_dev(y);

    if (std_x < core::EPSILON || std_y < core::EPSILON) return 0.0;

    return cov / (std_x * std_y);
}

/**
 * Calculate the nth percentile
 */
fn double percentile(double[] values, double p)
{
    if (values.len == 0) return 0.0;
    if (p < 0.0) p = 0.0;
    if (p > 100.0) p = 100.0;

    // Simple bubble sort
    for (usz i = 0; i < values.len - 1; i++) {
        for (usz j = 0; j < values.len - i - 1; j++) {
            if (values[j] > values[j + 1]) {
                double temp = values[j];
                values[j] = values[j + 1];
                values[j + 1] = temp;
            }
        }
    }

    double index = (p / 100.0) * (double)(values.len - 1);
    usz lower = (usz)index;
    usz upper = lower + 1;

    if (upper >= values.len) return values[values.len - 1];

    double weight = index - (double)lower;
    return values[lower] * (1.0 - weight) + values[upper] * weight;
}

/**
 * Calculate the interquartile range (IQR)
 */
fn double iqr(double[] values)
{
    double q1 = percentile(values, 25.0);
    double q3 = percentile(values, 75.0);
    return q3 - q1;
}

/**
 * Calculate the mode (most frequent value)
 * Returns the first mode found if multiple exist
 */
fn double mode(double[] values)
{
    if (values.len == 0) return 0.0;

    double mode_val = values[0];
    int max_count = 1;

    for (usz i = 0; i < values.len; i++) {
        int count = 1;
        for (usz j = i + 1; j < values.len; j++) {
            if (core::approx_equal(values[i], values[j])) {
                count++;
            }
        }
        if (count > max_count) {
            max_count = count;
            mode_val = values[i];
        }
    }

    return mode_val;
}
