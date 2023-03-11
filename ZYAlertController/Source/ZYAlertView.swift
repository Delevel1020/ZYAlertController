//
//  ZYAlertView.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/7.
//

import UIKit

// MARK: - alertAction

public enum ZYAlertActionStatu {
    case nomal // 白底 FFFFFF ， 黄色字体 333333 ， 高亮底色 EEEEEE ， 字体大小 15
    case cancle // 白底 FFFFFF ， 灰色字体 999999 ， 高亮底色 EEEEEE ，字体大小 15
    case ok // 橘红 E63629 ，白色字体 FFFFFF ，高亮底色 E63629 0.9 ，字体大小 15
}

public typealias ZYAlertActionHandler = (ZYAlertAction) -> Void

public struct ZYAlertAction {
    var title: String?
    var enable: Bool = true
    var statu: ZYAlertActionStatu = .nomal
    var handler: ZYAlertActionHandler?

    init(title: String = "确定", enable: Bool = true, statu: ZYAlertActionStatu = .nomal, handler: ZYAlertActionHandler? = nil) {
        self.title = title
        self.enable = enable
        self.statu = statu
        self.handler = handler
    }
}

// MARK: - alertView

public class ZYAlertView: UIView {
    public struct alertSizeConfig {
        /// 最大宽度
        var width: Double = UIScreen.main.bounds.size.width * 0.8
        /// 最大内容高度 如果超过改高度 则会自动滚动
        var messageHeight: Double = 275
    }

    public struct fontConfig {
        /// 标题 字体大小
        var title: UIFont = UIFont.pingFangMedium(15)
        /// 内容 字体大小
        var message: UIFont = UIFont.pingFangRegular(15)
        /// 普通按钮 字体大小
        var nomal: UIFont = UIFont.pingFangRegular(15)
        /// 取消按钮 字体大小
        var cancle: UIFont = UIFont.pingFangRegular(15)
        /// ok按钮 字体大小
        var ok: UIFont = UIFont.pingFangMedium(15)
    }

    public struct contentSpaceConfig {
        /// content 距离顶部间距
        var top: Double = 0
        /// content 距离左右两边间距
        var leftRight: Double = 0
    }

    public struct contentColorConfig {
        /// content 距离底部间距
        var titleColor: UIColor = UIColor.hexIntColor(hexInt: 0x333333)
        /// content 距离左右两边间距
        var messageColor: UIColor = UIColor.hexIntColor(hexInt: 0x333333)
    }

    public struct buttonSpaceConfig {
        /// button 距离顶部间距
        var top: Double = 0
        /// content 距离底部间距
        var bottom: Double = 0
        /// button之间 左右间距
        var leftRight: Double = 0
        /// button 高度
        var height: Double = 40
        /// button 圆角
        var radius: Double = 0
    }

    public struct buttonColorConfig {
        /// 普通按钮 颜色色值
        var nomal: UIColor = UIColor.hexIntColor(hexInt: 0xFFFFFF)
        /// 取消按钮 颜色色值
        var cancle: UIColor = UIColor.hexIntColor(hexInt: 0xFFFFFF)
        /// ok按钮 颜色色值
        var ok: UIColor = UIColor.hexIntColor(hexInt: 0xE63629)
    }

    public var alertSize: alertSizeConfig = alertSizeConfig() {
        didSet { layoutContent() }
    }

    public var fontSize: fontConfig = fontConfig() {
        didSet { layoutContent() }
    }

    public var titleSpace: contentSpaceConfig = contentSpaceConfig(top: 20, leftRight: 20) {
        didSet { layoutContent() }
    }

    public var messageSpce: contentSpaceConfig = contentSpaceConfig(top: 16, leftRight: 16) {
        didSet { layoutContent() }
    }

    public var buttonContentSpace: contentSpaceConfig = contentSpaceConfig(top: 24, leftRight: 0) {
        didSet { layoutContent() }
    }

    public var nomalButtonSpace: buttonSpaceConfig = buttonSpaceConfig(top: 0, bottom: 0, leftRight: 0, height: 50, radius: 0) {
        didSet { layoutContent() }
    }

    public var cancleButtonSpace: buttonSpaceConfig = buttonSpaceConfig(top: 0, bottom: 0, leftRight: 0, height: 50, radius: 0) {
        didSet { layoutContent() }
    }

    public var okButtonSpace: buttonSpaceConfig = buttonSpaceConfig(top: 0, bottom: 20, leftRight: 30, height: 50, radius: 25) {
        didSet { layoutContent() }
    }

    public var contentColor: contentColorConfig = contentColorConfig()
    public var buttonNomalBgColor: buttonColorConfig = buttonColorConfig()
    public var buttonHightBgColor: buttonColorConfig = buttonColorConfig(nomal: UIColor.hexIntColor(hexInt: 0xEEEEEE), cancle: UIColor.hexIntColor(hexInt: 0xEEEEEE), ok: UIColor.hexIntColor(hexInt: 0xE63629, alpha: 0.9))
    public var buttonTitleColor: buttonColorConfig = buttonColorConfig(nomal: UIColor.hexIntColor(hexInt: 0x333333), cancle: UIColor.hexIntColor(hexInt: 0x999999), ok: UIColor.hexIntColor(hexInt: 0xFFFFFF))

    /// 点击按钮是否 自动dismiss  默认是true
    public var clickedAutoHide: Bool = true
    /// 仅两个按钮 默认水平方向布局，超过两个，全部是竖直方向 并且该参数不起作用
    public var buttonHorizontal: Bool = true {
        didSet { layoutContent() }
    }

    /// 按钮的tag偏移量
    fileprivate let buttonTagOffset = 1000

    public private(set) var titleLB: UILabel = UILabel()
    public private(set) var messageLB: UILabel = UILabel()
    public private(set) var scrollView: UIScrollView = UIScrollView()
    public private(set) var buttonContentView: UIView = UIView()
    public private(set) var buttonVerLinView: UIView = UIView()
    public private(set) var buttonHorLineView: UIView = UIView()
    public private(set) var buttons: [UIButton] = [UIButton]()
    public private(set) var actions: [ZYAlertAction] = [ZYAlertAction]()

    public private(set) var title: String?
    public private(set) var message: String?

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String? = nil, message: String? = nil) {
        self.init()
        backgroundColor = UIColor.white
        self.title = title
        self.message = message
        addContentView()
    }

    override public func didMoveToSuperview() {
        if superview != nil {
            layoutContent()
        }
    }

    fileprivate func addContentView() {
        titleLB.text = title
        titleLB.textAlignment = .center
        titleLB.font = fontSize.title
        titleLB.textColor = contentColor.titleColor
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLB)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = false
        addSubview(scrollView)

        messageLB.text = message
        messageLB.numberOfLines = 0
        messageLB.textAlignment = .center
        messageLB.font = fontSize.message
        messageLB.textColor = contentColor.messageColor
        messageLB.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(messageLB)

        buttonContentView.translatesAutoresizingMaskIntoConstraints = false
        buttonContentView.isUserInteractionEnabled = true
        addSubview(buttonContentView)

        buttonVerLinView.translatesAutoresizingMaskIntoConstraints = false
        buttonVerLinView.backgroundColor = UIColor.hexIntColor(hexInt: 0xF1F1F1)
        buttonContentView.addSubview(buttonVerLinView)

        buttonHorLineView.translatesAutoresizingMaskIntoConstraints = false
        buttonHorLineView.backgroundColor = UIColor.hexIntColor(hexInt: 0xF1F1F1)
        buttonContentView.addSubview(buttonHorLineView)
    }
}

extension ZYAlertView {
    public func addAction(action: ZYAlertAction) {
        let button: UIButton = UIButton(type: .custom)
        let config = getButtonConfig(action)
        let spaceConfig = getButtonSpaceConfig(action)
        button.clipsToBounds = true
        button.layer.cornerRadius = spaceConfig.radius
        button.setTitle(action.title, for: .normal)
        button.isEnabled = action.enable
        button.titleLabel?.font = config.font
        button.setTitleColor(config.titleColor, for: .normal)
        button.setBackgroundImage(config.bgImage, for: .normal)
        button.setBackgroundImage(config.bgHightImage, for: .highlighted)
        button.tag = buttonTagOffset + buttons.count
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonClicked(sender:)), for: .touchUpInside)
        buttonContentView.addSubview(button)
        buttons.append(button)
        actions.append(action)
    }

    @objc fileprivate func actionButtonClicked(sender: UIButton) {
        let action: ZYAlertAction = actions[sender.tag - buttonTagOffset]
        if clickedAutoHide {
            let viewController: UIViewController? = currentVC
            guard let viewController = viewController, viewController.isKind(of: ZYAlertController.self) else { return }
            viewController.dismiss(animated: true)
        }
        guard let handler = action.handler else { return }
        handler(action)
    }
}

extension ZYAlertView {
    fileprivate func layoutContent() {
        removeAllConstraint()
        titleLB.removeAllConstraint()
        messageLB.removeAllConstraint()
        scrollView.removeAllConstraint()
        buttonVerLinView.removeAllConstraint()
        buttonHorLineView.removeAllConstraint()
        buttons.forEach { $0.removeAllConstraint() }
        scrollView.isScrollEnabled = false

        var originBottom: Double = 0

        if let title = title, !title.isBlank {
            let height = fontSize.title.lineHeight
            originBottom += (titleSpace.top + height)
            addConstraintAll(view: titleLB, topView: self, leftView: self, bottomView: nil, rightView: self, edge: UIEdgeInsets(top: titleSpace.top, left: titleSpace.leftRight, bottom: 0, right: -titleSpace.leftRight))
            titleLB.addConstraintSize(width: 0, height: height)
        }

        if let message = message, !message.isBlank {
            let preferrWidth: Double = alertSize.width - messageSpce.leftRight * 2
            let messageHeight: Double = message.heightFont(fontSize.message, width: preferrWidth)
            addConstraintTopToBottom(topView: titleLB, bottomView: scrollView, constant: messageSpce.top)
            addConstraintCenterX(view: scrollView, constant: 0)
            if messageHeight > alertSize.messageHeight {
                scrollView.isScrollEnabled = true
                originBottom += (messageSpce.top + alertSize.messageHeight)
                scrollView.addConstraintSize(width: preferrWidth, height: alertSize.messageHeight)
            } else {
                scrollView.isScrollEnabled = false
                originBottom += (messageSpce.top + messageHeight)
                scrollView.addConstraintSize(width: preferrWidth, height: messageHeight)
            }
            scrollView.contentSize = CGSize(width: preferrWidth, height: messageHeight)
            scrollView.addConstraintEdge(view: messageLB, edge: UIEdgeInsets.zero)
            messageLB.addConstraintSize(width: preferrWidth, height: messageHeight)
        }

        if buttons.count > 0 {
            var buttonHeight: Double = 0
            if buttons.count == 1 {
                let button: UIButton = buttons.first!
                let action: ZYAlertAction = actions.first!
                let config: buttonSpaceConfig = getButtonSpaceConfig(action)
                buttonHeight = config.height + config.top + config.bottom
                buttonVerLinView.isHidden = true
                buttonHorLineView.isHidden = (action.statu == .ok)
                button.addConstraintSize(width: 0, height: config.height)
                buttonContentView.addConstraintEdge(view: button, edge: UIEdgeInsets(top: config.top, left: config.leftRight, bottom: -config.bottom, right: -config.leftRight))
            } else if buttons.count == 2 {
                buttonVerLinView.isHidden = !buttonHorizontal // 如果是水平方向则不需要隐藏 竖直方向需要隐藏
                buttonHorLineView.isHidden = !buttonHorizontal // 如果是水平方向则不需要隐藏 竖直方向需要隐藏
                let button1: UIButton = buttons.first!
                let action1: ZYAlertAction = actions.first!
                let config1: buttonSpaceConfig = getButtonSpaceConfig(action1)
                let button2: UIButton = buttons.last!
                let action2: ZYAlertAction = actions.last!
                let config2: buttonSpaceConfig = getButtonSpaceConfig(action2)
                if buttonHorizontal {
                    /// 如果是水平方向
                    buttonHeight = max(config1.height + config1.top + config1.bottom, config2.height + config2.top + config2.bottom)
                    button1.addConstraintSize(width: 0, height: config1.height)
                    buttonContentView.addConstraintCenterY(view: button1, constant: 0)
                    buttonContentView.addConstraintAll(view: button1, topView: nil, leftView: buttonContentView, bottomView: nil, rightView: nil, edge: UIEdgeInsets(top: 0, left: config1.leftRight, bottom: 0, right: 0))
                    button2.addConstraintSize(width: 0, height: config2.height)
                    buttonContentView.addConstraintCenterY(view: button2, constant: 0)
                    buttonContentView.addConstraintLeftToRight(leftView: button1, rightView: button2, constant: config1.leftRight + config2.leftRight)
                    buttonContentView.addConstraintAll(view: button2, topView: nil, leftView: nil, bottomView: nil, rightView: buttonContentView, edge: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -config2.leftRight))
                    buttonContentView.addConstraintEquqlSize(view: button1, widthView: button2, heightView: nil)
                } else {
                    /// 如果是竖直方向
                    buttonHeight = (config1.height + config1.top + config1.bottom + config2.height + config2.top + config2.bottom)
                    button1.addConstraintSize(width: 0, height: config1.height)
                    button2.addConstraintSize(width: 0, height: config2.height)
                    buttonContentView.addConstraintAll(view: button1, topView: buttonContentView, leftView: buttonContentView, bottomView: nil, rightView: buttonContentView, edge: UIEdgeInsets(top: config1.top, left: config1.leftRight, bottom: 0, right: -config1.leftRight))
                    buttonContentView.addConstraintTopToBottom(topView: button1, bottomView: button2, constant: config1.bottom + config2.top)
                    buttonContentView.addConstraintAll(view: button2, topView: nil, leftView: buttonContentView, bottomView: buttonContentView, rightView: buttonContentView, edge: UIEdgeInsets(top: 0, left: config2.leftRight, bottom: -config2.bottom, right: -config2.leftRight))
                }
            } else {
                buttonVerLinView.isHidden = true
                buttonHorLineView.isHidden = true
                var currentButton: UIButton?
                var currentConfig: buttonSpaceConfig?
                for index in 0 ..< buttons.count {
                    let button: UIButton = buttons[index]
                    let action: ZYAlertAction = actions[index]
                    let config: buttonSpaceConfig = getButtonSpaceConfig(action)
                    buttonHeight += (config.top + config.bottom + config.height)
                    button.addConstraintSize(width: 0, height: config.height)
                    if let currentButton = currentButton {
                        buttonContentView.addConstraintTopToBottom(topView: currentButton, bottomView: button, constant: currentConfig!.bottom + config.top)
                        if index == (buttons.count - 1) {
                            buttonContentView.addConstraintAll(view: button, topView: nil, leftView: buttonContentView, bottomView: buttonContentView, rightView: buttonContentView, edge: UIEdgeInsets(top: 0, left: config.leftRight, bottom: -config.bottom, right: -config.leftRight))
                        } else {
                            buttonContentView.addConstraintAll(view: button, topView: nil, leftView: buttonContentView, bottomView: nil, rightView: buttonContentView, edge: UIEdgeInsets(top: 0, left: config.leftRight, bottom: 0, right: -config.leftRight))
                        }
                    } else {
                        if index == (buttons.count - 1) {
                            buttonContentView.addConstraintAll(view: button, topView: buttonContentView, leftView: buttonContentView, bottomView: buttonContentView, rightView: buttonContentView, edge: UIEdgeInsets(top: config.top, left: config.leftRight, bottom: -config.bottom, right: -config.leftRight))
                        } else {
                            buttonContentView.addConstraintAll(view: button, topView: buttonContentView, leftView: buttonContentView, bottomView: nil, rightView: buttonContentView, edge: UIEdgeInsets(top: config.top, left: config.leftRight, bottom: 0, right: -config.leftRight))
                        }
                    }
                    currentButton = button
                    currentConfig = config
                }
            }
            // 计算总高度
            originBottom += (buttonHeight + buttonContentSpace.top)
            addConstraintTopToBottom(topView: scrollView, bottomView: buttonContentView, constant: buttonContentSpace.top)
            addConstraintAll(view: buttonContentView, topView: nil, leftView: self, bottomView: self, rightView: self, edge: UIEdgeInsets(top: buttonContentSpace.top, left: buttonContentSpace.leftRight, bottom: 0, right: buttonContentSpace.leftRight))

            buttonHorLineView.addConstraintSize(width: 0, height: 0.5)
            buttonContentView.addConstraintAll(view: buttonHorLineView, topView: buttonContentView, leftView: buttonContentView, bottomView: nil, rightView: buttonContentView, edge: UIEdgeInsets.zero)
            buttonContentView.bringSubviewToFront(buttonHorLineView)

            buttonVerLinView.addConstraintSize(width: 0.5, height: 0)
            buttonContentView.addConstraintCenterX(view: buttonVerLinView, constant: 0)
            buttonContentView.addConstraintTopToBottom(topView: buttonHorLineView, bottomView: buttonVerLinView, constant: 0)
            buttonContentView.addConstraintAll(view: buttonVerLinView, topView: nil, leftView: nil, bottomView: buttonContentView, rightView: nil, edge: UIEdgeInsets.zero)
            buttonContentView.bringSubviewToFront(buttonVerLinView)
        }

        addConstraintSize(width: alertSize.width, height: originBottom)
    }
}

extension ZYAlertView {
    fileprivate func getButtonSpaceConfig(_ action: ZYAlertAction) -> buttonSpaceConfig {
        switch action.statu {
        case .nomal:
            return nomalButtonSpace
        case .cancle:
            return cancleButtonSpace
        case .ok:
            return okButtonSpace
        }
    }

    fileprivate func getButtonConfig(_ action: ZYAlertAction) -> (font: UIFont, titleColor: UIColor, bgImage: UIImage?, bgHightImage: UIImage?) {
        switch action.statu {
        case .nomal:
            return (fontSize.nomal, buttonTitleColor.nomal, buttonNomalBgColor.nomal.toImage, buttonHightBgColor.nomal.toImage)
        case .cancle:
            return (fontSize.cancle, buttonTitleColor.cancle, buttonNomalBgColor.cancle.toImage, buttonHightBgColor.cancle.toImage)
        case .ok:
            return (fontSize.ok, buttonTitleColor.ok, buttonNomalBgColor.ok.toImage, buttonHightBgColor.ok.toImage)
        }
    }
}
