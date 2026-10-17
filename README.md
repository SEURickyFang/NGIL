# NMPC-Guided Imitation Learning for RWS-Assisted ABS on Split-μ Roads

**Authors:** Ruiqi Fang, Weichao Zhuang, Jinhao Liang, Luca Dimauro, Alessandro Vigliani, Zhaoyu Qiu, Guodong Yin, and Aldo Sorniotti  
**Corresponding author:** Guodong Yin

## Overview

This work studies emergency braking of a three-axle, six-wheel vehicle on split-μ roads. Asymmetric tire–road friction creates a yaw moment, while rear-wheel steering (RWS) can help maintain directional stability. The controller coordinates braking and RWS at the reference level: it adjusts the left and right wheel-slip references and the rear-steering reference, while a six-wheel anti-lock braking system (ABS) continues to regulate individual brake torques.

An NMPC expert accounts for combined tire slip and vehicle dynamics. Its coordination policy is transferred to a lightweight neural controller through expert demonstrations and closed-loop data aggregation. The intent is to avoid solving a nonlinear optimization problem during every online control update while retaining the expert's useful coordination behavior.

## Main ideas

- **Reference-level coordination:** the learned policy commands left/right slip-reference release and rear-steering reference, rather than replacing the wheel-level ABS.
- **Physics-informed expert:** NMPC generates coordinated actions using a six-wheel vehicle model with combined-slip tire forces.
- **Learning under closed-loop state shift:** training uses expert demonstrations and additional expert labels on states reached by the learned controller.
- **Ablation analysis:** the animations below compare NGIL with variants that remove member averaging, closed-loop data aggregation, or mirror-based training.

## Control framework

![Control framework](assets/framework.png)

## Main comparison animations

Each animation shows the vehicle paths and six-wheel poses for NMPC, BC-MLP, and NGIL in one coordinate system. The lower panels show lateral offset, heading angle, and rear-steering angle.

| Scenario | Animation | Scenario | Animation |
|---|---|---|---|
| S1 | ![S1 main comparison](assets/animations/main/S1.gif) | G1 | ![G1 main comparison](assets/animations/main/G1.gif) |
| S2 | ![S2 main comparison](assets/animations/main/S2.gif) | G2 | ![G2 main comparison](assets/animations/main/G2.gif) |
| S3 | ![S3 main comparison](assets/animations/main/S3.gif) | G3 | ![G3 main comparison](assets/animations/main/G3.gif) |
| S4 | ![S4 main comparison](assets/animations/main/S4.gif) | G4 | ![G4 main comparison](assets/animations/main/G4.gif) |
| S5 | ![S5 main comparison](assets/animations/main/S5.gif) | G5 | ![G5 main comparison](assets/animations/main/G5.gif) |
|  |  | G6 | ![G6 main comparison](assets/animations/main/G6.gif) |

## Ablation animations

Each animation compares four vehicles: NGIL, no member averaging, no DAgger-style closed-loop data aggregation, and no mirror-based training. The same vehicle scale, road coloring, and plot layout are used as in the main animations.

| Scenario | Animation | Scenario | Animation |
|---|---|---|---|
| S1 | ![S1 ablation](assets/animations/ablation/S1.gif) | G1 | ![G1 ablation](assets/animations/ablation/G1.gif) |
| S2 | ![S2 ablation](assets/animations/ablation/S2.gif) | G2 | ![G2 ablation](assets/animations/ablation/G2.gif) |
| S3 | ![S3 ablation](assets/animations/ablation/S3.gif) | G3 | ![G3 ablation](assets/animations/ablation/G3.gif) |
| S4 | ![S4 ablation](assets/animations/ablation/S4.gif) | G4 | ![G4 ablation](assets/animations/ablation/G4.gif) |
| S5 | ![S5 ablation](assets/animations/ablation/S5.gif) | G5 | ![G5 ablation](assets/animations/ablation/G5.gif) |
|  |  | G6 | ![G6 ablation](assets/animations/ablation/G6.gif) |

## Code availability

The core implementation will be released after the paper is accepted.
