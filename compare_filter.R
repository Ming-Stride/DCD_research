# ============================================
# 练手：对比不同低通滤波截止频率对协同结果的影响
# 参考Shuman et al. 2019：推荐LPf=4~10Hz，包默认20Hz偏高
# ============================================

library(musclesyneRgies)
library(ggplot2)

# 加载示例数据
data("RAW_DATA")

# ---------- 方案A：包默认 LPf = 20Hz ----------
cat("===== 方案A：低通滤波 20Hz（包默认）=====\n")

FILT_20 <- lapply(RAW_DATA, function(x) {
  filtEMG(x, LPf = 20)
})

NORM_20 <- lapply(FILT_20, function(x) {
  normEMG(x, trim = TRUE, cy_max = 3, cycle_div = c(100, 100))
})

# 算R²曲线
get_r2 <- function(syn) {
  # syn$R2 是 data.frame，包含 $synergies 和 $R2 两列
  return(as.numeric(syn$R2$R2))
}

r2_20 <- numeric(10)
for (n in 1:10) {
  syn <- synsNMF(NORM_20[[1]], fixed_syns = n, runs = 3)
  r2_20[n] <- get_r2(syn)
  cat(n, "个协同: R² =", round(r2_20[n], 4), "\n")
}

# ---------- 方案B：Shuman推荐 LPf = 10Hz ----------
cat("\n===== 方案B：低通滤波 10Hz（Shuman推荐）=====\n")

FILT_10 <- lapply(RAW_DATA, function(x) {
  filtEMG(x, LPf = 10)
})

NORM_10 <- lapply(FILT_10, function(x) {
  normEMG(x, trim = TRUE, cy_max = 3, cycle_div = c(100, 100))
})

r2_10 <- numeric(10)
for (n in 1:10) {
  syn <- synsNMF(NORM_10[[1]], fixed_syns = n, runs = 3)
  r2_10[n] <- get_r2(syn)
  cat(n, "个协同: R² =", round(r2_10[n], 4), "\n")
}

# ---------- 对比结果 ----------
cat("\n===== 对比汇总 =====\n")
results <- data.frame(
  n_syns = 1:10,
  R2_LPf20 = round(r2_20, 4),
  R2_LPf10 = round(r2_10, 4),
  diff = round(r2_10 - r2_20, 4)
)
print(results)

# 找达到R²≥0.90需要的协同数量
n_20 <- which(r2_20 >= 0.90)[1]
n_10 <- which(r2_10 >= 0.90)[1]

cat("\n达到R²≥0.90所需协同数量：\n")
cat("  LPf=20Hz:", n_20, "个协同\n")
cat("  LPf=10Hz:", n_10, "个协同\n")

# ---------- 画R²对比曲线 ----------
plot_df <- data.frame(
  n = rep(1:10, 2),
  R2 = c(r2_20, r2_10),
  filter = factor(rep(c("LPf=20Hz (default)", "LPf=10Hz (Shuman)"), each = 10))
)

p <- ggplot(plot_df, aes(x = n, y = R2, color = filter)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0.90, linetype = "dashed", color = "red") +
  annotate("text", x = 8, y = 0.905, label = "R²=0.90阈值", color = "red") +
  labs(x = "协同数量", y = "R²（重构方差解释率）",
       title = "不同低通滤波频率对R²的影响",
       subtitle = "参考Shuman et al. 2019方法学建议") +
  theme_bw(base_size = 14) +
  theme(legend.position = c(0.8, 0.3))

ggsave("filter_comparison.png", p, width = 8, height = 5, dpi = 300)
cat("\n对比图已保存：filter_comparison.png\n")
