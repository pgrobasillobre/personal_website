---
title: Profiling a hot loop
summary: Found false sharing; fixed with private accumulators + final reduction.
tags: [cpp, openmp, profiling]
date: 2025-08-25
---
Small memo on locating cache-line ping-pong in an OpenMP reduction and the fix that stabilized speedup.