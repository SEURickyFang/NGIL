# Public interface overview

This document describes the architecture shown in the paper. It is not a runnable controller specification.

The vehicle-level coordinator receives measured vehicle motion, road-friction information available at the current vehicle position, wheel-slip feedback, and actuator feedback. It produces three references: a left-side slip-reference release ratio, a right-side slip-reference release ratio, and a common rear-axle steering reference. The wheel-level ABS and steering actuators then convert these references into physical commands.

| Signal | Unit | Meaning |
| --- | --- | --- |
| Longitudinal speed | m/s | Vehicle speed along its forward axis |
| Lateral speed | m/s | Vehicle speed toward its left side |
| Yaw rate | rad/s | Positive for counterclockwise yaw |
| Lateral offset | m | Signed displacement from the straight reference path |
| Heading error | rad | Vehicle heading relative to that path |
| Left/right friction estimates | dimensionless | Available information at the current position; no future road preview |
| Six measured braking slip ratios | dimensionless | Positive magnitudes in this public convention |
| Rear-steering feedback | rad | Measured third-axle steering angle |
| Left/right release ratios | dimensionless | Coordinator outputs bounded between 0 and 1 |
| Rear-steering reference | rad | Coordinator output before actuator response |

The schematic wheel names are FL, FR, ML, MR, RL, and RR. The CSV in `examples/` does not contain controller inputs, trained policies, or simulation trajectories. Its numbers are synthetic and must not be interpreted as paper results. The separate `code/` and `models/` directories contain the controller preview described in the README.
