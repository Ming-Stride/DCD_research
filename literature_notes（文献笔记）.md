# DCD肌肉协同文献笔记

> 整理日期：2026-09-27
> 方向：DCD儿童步态肌肉协同分析（NMF方法）

---

## 文献一：Yam & Fong (2018) — DCD步态肌肉激活

### 基本信息
- **题目**：Leg muscle activation patterns during walking and leg lean mass are different in children with and without developmental coordination disorder
- **期刊**：Research in Developmental Disabilities, 73: 87-95
- **作者**：Timothy T.T. Yam, Shirley S.M. Fong（香港大学公共卫生学院）
- **DOI**：10.1016/j.ridd.2017.12.014
- **PMID**：29275080

### 研究设计
- **样本**：51个DCD儿童（38男13女，7.95±1.04岁） vs 52个对照（34男18女，8.02±1.00岁）
- **设备**：跑步机走路、表面肌电（sEMG）测右腿、电角度计+足底开关、DXA测瘦体重
- **任务**：跑步机步行

### 核心发现
1. **下肢瘦体重更低**：DCD组下肢瘦体重、附肢瘦体重指数显著低于对照组
2. **三个时相峰值激活降低**：

| 步态时相 | 受累肌肉 | DCD表现 |
|----------|---------|---------|
| 足跟撞击期 | 腓肠肌内侧（GM） | 峰值激活更低 |
| 摆动早期 | 股二头肌（BF） | 峰值激活更低 |
| 摆动晚期 | 腓肠肌内侧（GM） | 峰值激活更低 |

### 方法学局限（=本研究创新点）
- ❌ 只看单块肌肉峰值激活，未做NMF肌肉协同分解
- ❌ 未分析神经效率（R²/VAF）
- ❌ 未看跨试次协同变异性
- ❌ 未解释"为什么DCD儿童激活模式异常"

### 本研究如何引用
- **引言**：Yam & Fong发现DCD儿童在足跟撞击和摆动期单块肌肉峰值激活降低，但未探索肌肉协同层面的中枢神经控制策略
- **方法**：参考其步态时相划分、肌肉电极放置位置
- **讨论**：本研究进一步探索DCD儿童是否需要更多协同模块完成步态

---

## 文献二：Shuman et al. (2019) — EMG处理对肌肉协同的影响

### 基本信息
- **题目**：Electromyography Data Processing Impacts Muscle Synergies during Gait for Unimpaired Children and Children with Cerebral Palsy
- **期刊**：Frontiers in Computational Neuroscience
- **作者**：Benjamin R. Shuman, Michael H. Schwartz, Katrine M. Steele（华盛顿大学）
- **样本**：113个脑瘫儿童(CP) + 73个正常发育儿童(TD)，共186人

### 研究设计
- **被试**：赤脚走路，5块下肢肌肉
- **测试变量**：
  - 低通滤波截止频率：4Hz、10Hz、20Hz、30Hz、40Hz
  - 是否做单位方差标准化（unit variance scaling）

### 核心发现
1. **低通滤波截止频率显著影响tVAF**：
   - 4Hz vs 40Hz，1个协同的tVAF相差9.3个百分点
   - 滤波截止频率越高，需要越多协同才能达到相同VAF
2. **z-score标准化（walk-DMC）**：能显著降低不同滤波参数之间的偏差
3. **协同权重和激活曲线受影响较小**：只要参数固定，协同形态稳定

### 方法学指导
- ✅ 低通滤波推荐用 **4~10Hz**（不是包默认的20Hz）
- ✅ 报告结果时建议同时报告原始tVAF和z-score标准化后的walk-DMC
- ⚠️ 滤波参数必须在方法部分明确写出，否则结果不可重复

---

## 补充文献：Van der Krogt et al.

- **主题**：BoNT-A治疗前后EMG处理选择对肌肉协同的影响
- **关键发现**：滤波参数不仅影响结果，还可能改变治疗前后的结论
- **启示**：做干预研究时，滤波参数必须在研究设计阶段就固定

---

## 我的研究方法模板（从这两篇提炼）

### EMG预处理流程
1. 原始信号：采样率≥1000Hz
2. 带通滤波：20-500Hz
3. 全波整流
4. 低通滤波：**10Hz**（线性包络）
5. 标准化：MVC标准化 或 自身最大值标准化
6. 时间归一化：每个步态周期归一到100%

### 协同提取流程
1. NMF算法，runs=5次取最优
2. 协同数量：tVAF≥90% 或 elbow method
3. 跨受试者聚类：k-means
4. 统计指标：协同数量、权重余弦相似度、CoA、FWHM

---

## 待读文献清单
- [ ] Wilson et al. (2017) — DCD认知与神经影像系统综述
- [ ] Goudriaan et al. (2019) — 188名CP儿童肌肉协同结构
- [ ] Kieliba et al. — EMG预处理对协同的影响（上肢参考）
- [ ] Diamond et al. (2013) — DCD跑步推进策略
