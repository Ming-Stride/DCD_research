# ============================================
# R复现SPSS分析：同一份数据两种方法对比验证
# 目的：用R重跑SPSS做过的分析，确认结果一致
# ============================================

# 读取数据（注意文件名带中文括号，用完整路径）
data <- read.csv("D:/DCD_research/DCD_research/DCD_simulated_data（模拟数据）.csv")

# 检查数据
cat("===== 数据结构 =====\n")
str(data)
cat("\n分组情况：\n")
table(data$Group)  # 1=DCD, 2=对照

# 把Group变成因子，方便分组比较
data$Group_f <- factor(data$Group, levels = c(1, 2),
                       labels = c("DCD", "Control"))

# ============================================
# 1. 独立样本t检验：GM_peak两组比较
#    （对应SPSS的 分析->比较平均值->独立样本T检验）
# ============================================
cat("\n\n===== 1. 独立样本t检验：GM_peak (DCD vs Control) =====\n")
t_test_GM <- t.test(GM_peak ~ Group_f, data = data, var.equal = FALSE)
print(t_test_GM)

# 两组均值
cat("\n两组GM_peak均值：\n")
print(tapply(data$GM_peak, data$Group_f, mean))

# ============================================
# 2. Mann-Whitney U检验：Synergy_count两组比较
#    （对应SPSS 分析->非参数检验->2个独立样本）
# ============================================
cat("\n\n===== 2. Mann-Whitney U：Synergy_count =====\n")
mwu <- wilcox.test(Synergy_count ~ Group_f, data = data)
print(mwu)

# 秩均值
cat("\n两组秩均值：\n")
rank_data <- rank(data$Synergy_count)
print(tapply(rank_data, data$Group_f, mean))

# ============================================
# 3. 皮尔逊相关：MABC2 vs Synergy_count
#    （对应SPSS 分析->相关->双变量）
# ============================================
cat("\n\n===== 3. 皮尔逊相关：MABC2 vs Synergy_count =====\n")
cor_result <- cor.test(data$MABC2_score, data$Synergy_count, method = "pearson")
print(cor_result)

# 完整相关矩阵
cat("\n完整相关矩阵：\n")
cor_matrix <- cor(data[, c("MABC2_score", "Gait_speed", "Stride_length",
                           "GM_peak", "BF_peak", "Synergy_count")])
print(round(cor_matrix, 3))

# ============================================
# 4. 多元线性回归：MABC2 ~ Synergy_count + BF_peak
#    （对应SPSS 分析->回归->线性，干净模型）
# ============================================
cat("\n\n===== 4. 线性回归：MABC2 ~ Synergy_count + BF_peak =====\n")
model <- lm(MABC2_score ~ Synergy_count + BF_peak, data = data)
summary(model)

# VIF（共线性诊断）
cat("\nVIF（方差膨胀因子）：\n")
if (require(car, quietly = TRUE)) {
  print(vif(model))
} else {
  # 手算VIF
  X1 <- lm(Synergy_count ~ BF_peak, data = data)
  X2 <- lm(BF_peak ~ Synergy_count, data = data)
  cat("Synergy_count VIF:", 1 / (1 - summary(X1)$r.squared), "\n")
  cat("BF_peak VIF:", 1 / (1 - summary(X2)$r.squared), "\n")
}

# ============================================
# 5. 汇总对比表
# ============================================
cat("\n\n========== R vs SPSS 结果对比 ==========\n")
cat("SPSS结果（昨天的）：\n")
cat("  GM_peak t检验: t≈-10.98, p<.001\n")
cat("  Synergy_count Mann-Whitney: U=147.0, Z=-3.52, p<.001\n")
cat("  MABC2~Synergy_count相关: r=-.714, p<.001\n")
cat("  回归MABC2~Synergy+BF: R²adj=.954, Synergy p=.004, BF p<.001\n")
cat("\nR结果（本次）：见上方输出，对比即可确认一致性\n")
