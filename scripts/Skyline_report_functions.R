## tailing factor calculation

calculate_tailingFactor <- function(chrom_data) {
  # Find the maximum intensity and the corresponding retention time
  spline_fit <- smooth.spline(chrom_data$chr_time, chrom_data$chr_intensity, spar = 0.3)
  
  
  max_idx <- which.max(spline_fit$y)  # Index of maximum intensity
  max_intensity <- max(chrom_data$chr_intensity)  # Maximum intensity value
  fivePerc_max <- max_intensity * 0.05
  
  
  # Find points on the left side of the peak
  
  
  if (all(spline_fit$y[1:max_idx] > fivePerc_max)) {
    left_rt_max <- spline_fit$x[1] # Use rtmin as fallback
  } else {
    left_idx <- max(which(spline_fit$y[1:max_idx] <= fivePerc_max))  # Closest point on the left below half max
    left_rt1 <- spline_fit$x[left_idx]  # RT before half max crossing
    left_rt2 <- spline_fit$x[left_idx + 1]  # RT after half max crossing
    left_y1 <- spline_fit$y[left_idx]  # Intensity before half max
    left_y2 <- spline_fit$y[left_idx + 1]  # Intensity after half max
    
    #' Linear interpolation to find the exact RT at fivePerc_max on the left
    
    left_rt_max <- left_rt1 + ((fivePerc_max - left_y1) / (left_y2 - left_y1)) * (left_rt2 - left_rt1)
    
  }
  
  
  #' Find points on the right side of the peak
  
  if (all(spline_fit$y[max_idx:length(spline_fit$y)] > fivePerc_max)) {
    right_rt_max <- spline_fit$x[length(spline_fit$y)]  # Use rtmax as fallback
  } else {
    right_idx <- min(which(spline_fit$y[max_idx:length(spline_fit$y)] <= fivePerc_max)) + max_idx - 1  # Closest point on the right below half max
    right_rt1 <- spline_fit$x[right_idx - 1]  # RT before half max crossing
    right_rt2 <- spline_fit$x[right_idx]  # RT after half max crossing
    right_y1 <- spline_fit$y[right_idx - 1]  # Intensity before half max
    right_y2 <- spline_fit$y[right_idx]  # Intensity after half max
    
    # Linear interpolation to find the exact RT at fivePerc_max on the right
    right_rt_max <- right_rt1 + (fivePerc_max - right_y1) / (right_y2 - right_y1) * (right_rt2 - right_rt1)
    
  }
  
  
  
  # Calculate the C and D for tailing
  rt_of_max <- chrom_data$chr_time[which.max(chrom_data$chr_intensity)]  
  
  C <- rt_of_max - left_rt_max
  D <- right_rt_max - rt_of_max
  
  # Calculate the tailing
  tailing <- (C+D)/(2*C)
  
  return(tailing)
}

## asymmetry calculation
calculate_asymmetry <- function(chrom_data) {
  # Find the maximum intensity and the corresponding retention time
  spline_fit <- smooth.spline(chrom_data$chr_time, chrom_data$chr_intensity, spar = 0.3)
  
  
  max_idx <- which.max(spline_fit$y)  # Index of maximum intensity
  max_intensity <- max(chrom_data$chr_intensity)  # Maximum intensity value
  tenPerc_max <- max_intensity * 0.1
  
  
  # Calculate left retention time (rt)
  if (all(spline_fit$y[1:max_idx] > tenPerc_max)) {
    left_rt_max <- spline_fit$x[1] # Use rtmin as fallback
  } else {
    left_idx <- max(which(spline_fit$y[1:max_idx] <= tenPerc_max))  # Closest point on the left below half max
    left_rt1 <- spline_fit$x[left_idx]  # RT before half max crossing
    left_rt2 <- spline_fit$x[left_idx + 1]  # RT after half max crossing
    left_y1 <- spline_fit$y[left_idx]  # Intensity before half max
    left_y2 <- spline_fit$y[left_idx + 1]  # Intensity after half max
    
    # Linear interpolation to find the exact RT at tenPerc_max on the left
    left_rt_max <- left_rt1 + ((tenPerc_max - left_y1) / (left_y2 - left_y1)) * (left_rt2 - left_rt1)
    
  }
  
  
  # Find points on the right side of the peak
  
  if (all(spline_fit$y[max_idx:length(spline_fit$y)] > tenPerc_max)) {
    right_rt_max <- spline_fit$x[length(spline_fit$y)]  # Use rtmax as fallback
  } else {
    right_idx <- min(which(spline_fit$y[max_idx:length(spline_fit$y)] <= tenPerc_max)) + max_idx - 1  # Closest point on the right below half max
    right_rt1 <- spline_fit$x[right_idx - 1]  # RT before half max crossing
    right_rt2 <- spline_fit$x[right_idx]  # RT after half max crossing
    right_y1 <- spline_fit$y[right_idx - 1]  # Intensity before half max
    right_y2 <- spline_fit$y[right_idx]  # Intensity after half max
    
    # Linear interpolation to find the exact RT at tenPerc_max on the right
    right_rt_max <- right_rt1 + (tenPerc_max - right_y1) / (right_y2 - right_y1) * (right_rt2 - right_rt1)
    
  }
  
  
  
  # Calculate the A and B for asymmetry
  rt_of_max <- chrom_data$chr_time[which.max(chrom_data$chr_intensity)]  
  
  A <- rt_of_max - left_rt_max
  B <- right_rt_max - rt_of_max
  
  
  # Calculate the asymmetry
  asymmetry <- B/A
  
  return(asymmetry)
}

# plotting chromatogram - data wrangle
transform_df_tidyverse <- function(df) {
  df %>%
    rowwise() %>%
    mutate(
      col1_list = list(as.numeric(unlist(strsplit(Raw_Times, ",")))),
      col2_list = list(as.numeric(unlist(strsplit(Raw_Intensities, ","))))
    ) %>%
    tidyr::unnest(c(col1_list, col2_list)) %>%
    dplyr::rename(chr_time = col1_list, chr_intensity = col2_list) %>%
    select(-Raw_Times, -Raw_Intensities)
}
