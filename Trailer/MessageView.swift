
class MessageView: NSView {

	init(frame frameRect:NSRect, message:NSAttributedString) {
		super.init(frame:frameRect)
		let messageRect = CGRectInset(self.bounds, CGFloat(MENU_WIDTH)*0.13, 0)
		let messageField = CenterTextField(frame:messageRect)
		messageField.autoresizingMask = NSAutoresizingMaskOptions.ViewHeightSizable | NSAutoresizingMaskOptions.ViewWidthSizable;
		messageField.attributedStringValue = message
		self.addSubview(messageField)
	}

	required init?(coder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
