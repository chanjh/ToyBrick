# ToyBrick
ToyBrick is an iOS Project Modular Framework written by Swift, which is inspired by [Alibaba/BeeHive](https://github.com/alibaba/BeeHive).

![](https://img.shields.io/badge/language-swift-orange.svg)
![](https://img.shields.io/cocoapods/v/ToyBrick.svg?style=flat)
![](https://img.shields.io/cocoapods/p/ToyBrick.svg?style=flat)

[![](https://img.shields.io/badge/WeiBo-@陈某豪-blue.svg)](https://weibo.com/bj416)

## Todo List

* ⛳️ Milestone 01
- [x] 基于 Module 实现 App 生命周期托管 
- [x] 基于 Service 实现模块解耦
- [ ] 重构 Module Manager
    - [ ] 暂时去除加载 plist 的支持，去除 string -> class 的过程。重新设计注册过程，不再依赖 OC 的 Runtime 特性
- [ ] Module 优化
    - [x] 去除 BeeHive 的影子
    - [ ] 支持使用 plist 跨 Swift Module 注册（待定）
- [ ] 去除 Objective-C 的实现
- [ ] 完善 Demo 代码
- [ ] 单例统一托管

* ⛳️ Milestone 02
- [ ] 单元测试
- [ ] Module 继续优化
    - [ ] Module init 时机优化
    - [ ] Module：支持自定义事件
- [ ] Container：容器化现有的 AppDelegate，不依赖 App 生命周期
- [ ] Module 变为基于 Service 的实例化
- [ ] 扩展 Service Name 字段，实现类似路由的功能
- [ ] ……


## Contribution

* You can
- [ ] 🐞 抓虫！
- [ ] 📖 翻译文档
- [ ] ⚔️ 书写单元测试
- [ ] 💡 贡献想法和代码
