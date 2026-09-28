# 加载包和示例数据
library(musclesyneRgies)
data("RAW_DATA")

# 1. 截取步态周期（可选，保留3个周期）
RAW_DATA_subset <- lapply(RAW_DATA, function(x) {
  subsetEMG(x, cy_max = 3, cy_start = 1)
})

# 2. 滤波（默认参数：去均值→50Hz高通→整流→20Hz低通→包络）
FILT_EMG <- lapply(RAW_DATA, filtEMG)

# 3. 时间归一化（每个步态周期分成支撑相100点+摆动相100点）
NORM_EMG <- lapply(FILT_EMG, function(x) {
  normEMG(x, trim = TRUE, cy_max = 3, cycle_div = c(100, 100))
})

# 4. NMF提取肌肉协同
SYNS <- lapply(NORM_EMG, synsNMF)

# 5. 画单个试次的协同图
plot_syn_trials(SYNS[[1]], max_syns = 4, trial = names(SYNS)[1])

# 6. 加载包自带的多受试者数据，做K-means聚类
data("SYNS")
SYNS_classified <- classify_kmeans(SYNS)

# 7. 画你之前看到的那张经典图
plot_classified_syns(SYNS_classified, condition = "TW", dark_mode = TRUE)
r2_results <- c()
for (n in 1:10) {
  syn <- synsNMF(NORM_EMG[[1]], fixed_syns = n, runs = 3)
  r2_results <- numeric(10)
  for (n in 1:10) {
    syn <- synsNMF(NORM_EMG[[1]], fixed_syns = n, runs = 3)
    r2_results <- numeric(10)
    for (n in 1:10) {
      syn <- synsNMF(NORM_EMG[[1]], fixed_syns = n, runs = 3)
      r2_results[n] <- as.numeric(unlist(syn$R2))[1]
      cat(n, "个协同: R² =", round(as.numeric(unlist(syn$R2))[1], 4), "\n")
    }
    # === 论文级出图 ===
    library(ggplot2)
    
    # 白底、黑色线、灰色误差带
    pp <- plot_classified_syns(
      SYNS_classified,
      condition = "TW",
      dark_mode = FALSE,           # 白底
      line_col = "black",          # 黑线
      sd_col = "grey80"            # 浅灰误差带
    )
    
    # 保存成高清图（论文要求300dpi）
    ggsave("synergy_plot.tiff", pp, width = 180, height = 150, dpi = 300, units = "mm")