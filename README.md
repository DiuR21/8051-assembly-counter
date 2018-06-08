---
title: 8051嵌入式 汇编 EBU5475
date: 2018-06-08 15:01:02
tags: [汇编]
thumbnail: 
categories: 
- 工程
---
# 简介

功能：实现于模拟keybord以及模拟Led矩阵上的两位数倒计时。

平台：win10、MCU 8051 模拟器、模拟Keyboard、模拟Led矩阵

开发语言：51汇编

# 程序结构

![Pic1](http://ok8er9pip.bkt.clouddn.com/1528442431.png?imageMogr2/thumbnail/!70p)

# 实现功能

- 输入部分
  - 设置两位数倒计时时间
  - 按下‘\*'时，结束输入
- 倒计时部分
  - 按下'\*'时，暂停倒计时
  - 按下'0'时，重设倒计时时间
- 绘图部分
  - 绘图，没什么好说，就绘图。

