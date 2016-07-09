//
//  Extensions.swift
//  DzematApp
//
//  Created by Irfan Godinjak on 03/07/16.
//  Copyright © 2016 eu.devlogic. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

private var kAssociationKeyNextField: UInt8 = 0
private var kAssociationKeyViewBeforeNetworkDisconnection: UInt8 = 0


/**
 *  Added extension to UITextField to be able to set next field for easy targeting
 */
extension UITextField {
    var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}


/**
 *  Extension to the UIWindow class to store the previous view that was on screen when a network connection issue occurs
 *  This allows us to go back to the correct place when network connectivity restored
 */
extension UIWindow {
    var viewBeforeNetworkDisconnection: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyViewBeforeNetworkDisconnection) as? UIViewController
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyViewBeforeNetworkDisconnection, newField, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}


/**
 These extensions allow us to do <, and == with NSDate's
 
 - parameter lhs: left date
 - parameter rhs: right date
 
 - returns: comparison
 */
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

extension NSDate {
    struct Date {
        static let formatter = NSDateFormatter()
    }
    var formatted: String {
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        Date.formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        Date.formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        Date.formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return Date.formatter.stringFromDate(self)
    }
    var startOfWeek: NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Weekday], fromDate: self)
        components.day = components.day - components.weekday + 1
        return calendar.dateFromComponents(components)
    }
}

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
}


extension UIButton {
    var titleLabelFont: UIFont! {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
}

extension UILabel {
    var labelFont: UIFont! {
        get { return self.font }
        set { self.font = newValue }
    }
}

extension UITextField {
    var textFont: UIFont! {
        get { return self.font}
        set { self.font = newValue }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    /// A `UIColor`'s HSB (hue, saturation, brightness) values.
    struct HSBView {
        var hue = CGFloat()
        var saturation = CGFloat()
        var brightness = CGFloat()
        var alpha = CGFloat()
    }
    /// Gets the `HSBView` of a `UIColor`.
    /// * Returns: A `HSBView` of a `UIColor` if HSB values can be retrieved; otherwise, nil.
    func getHSBView() -> HSBView? {
        var hsbView = HSBView()
        return self.getHue(&hsbView.hue, saturation: &hsbView.saturation, brightness: &hsbView.brightness, alpha: &hsbView.alpha) ? hsbView : nil
    }
}

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}

extension UIView {
    // TODO: document
    func applyCircleMask() {
        contentMode = .ScaleAspectFill
        layer.cornerRadius = frame.height.half
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
extension UILabel {
    // TODO: document
    func sizeWithAttributes(attrs: [String : AnyObject]?) -> CGSize {
        guard let text = text else { fatalError("text must be set before UILabel.size is accessed") }
        return text.sizeWithAttributes(attrs)
    }
}
extension UITextField {
    // TODO: document
    func sizeWithAttributes(attrs: [String : AnyObject]?) -> CGSize {
        guard let text = text else { fatalError("text must be set before UILabel.size is accessed") }
        if text == "", let placeholder = placeholder {
            return placeholder.sizeWithAttributes(attrs)
        }
        return text.sizeWithAttributes(attrs)
    }
}
// TODO: perhaps this extension belongs on a more general type than CGFloat... or make a protocol Halvable with only this computed property & make numeric types adhere to it
extension CGFloat {
    // TODO: make more general (i.e. Divisible protocol which CGFloat, Int, etc. adhere to which defines divideBy(n: Int???))
    // TODO: document
    var half: CGFloat {
        return self / 2
    }
}

/**
 Use this function instead of CGRectMake throughout the app. It prevents misaligned images.
 
 - parameter x:      origin.x
 - parameter y:      origin.y
 - parameter width:  width
 - parameter height: height
 
 - returns: IntegralCGRect
 */
public func iTyRectMake(x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRectIntegral(CGRectMake(x, y, width, height))
}

extension UIApplication {
    
    class func appVersion() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "Version: \(version)" : "Version: \(version)\nBuild: \(build)"
    }
}
extension NSCalendar {
    // TODO: document
    var daysInWeek: UInt {
        return UInt(weekdaySymbols.count)
    }
    // TODO: document
    var daysInYear: UInt {
        let dateComponents = components([.Year], fromDate: NSDate())
        let startOfThisYear = dateFromComponents(dateComponents)
        dateComponents.year += 1
        let startOfNextYear = dateFromComponents(dateComponents)
        return UInt(components([.Day], fromDate: startOfThisYear!, toDate: startOfNextYear!, options: []).day)
    }
}
// TODO: document
extension NSUserDefaults {
    func objectForKey(userDefault: UserDefault) -> AnyObject? {
        return objectForKey(userDefault.rawValue)
    }
    func setObject(value: AnyObject?, forKey userDefault: UserDefault) {
        setObject(value, forKey: userDefault.rawValue)
    }
    func removeObjectForKey(userDefault: UserDefault) {
        removeObjectForKey(userDefault.rawValue)
    }
    func stringForKey(userDefault: UserDefault) -> String? {
        return stringForKey(userDefault.rawValue)
    }
    func arrayForKey(userDefault: UserDefault) -> [AnyObject]? {
        return arrayForKey(userDefault.rawValue)
    }
    func dictionaryForKey(userDefault: UserDefault) -> [String : AnyObject]? {
        return dictionaryForKey(userDefault.rawValue)
    }
    func dataForKey(userDefault: UserDefault) -> NSData? {
        return dataForKey(userDefault.rawValue)
    }
    func stringArrayForKey(userDefault: UserDefault) -> [String]? {
        return stringArrayForKey(userDefault.rawValue)
    }
    func integerForKey(userDefault: UserDefault) -> Int {
        return integerForKey(userDefault.rawValue)
    }
    func floatForKey(userDefault: UserDefault) -> Float {
        return floatForKey(userDefault.rawValue)
    }
    func doubleForKey(userDefault: UserDefault) -> Double {
        return doubleForKey(userDefault.rawValue)
    }
    func boolForKey(userDefault: UserDefault) -> Bool {
        return boolForKey(userDefault.rawValue)
    }
    @available(iOS 4.0, *)
    func URLForKey(userDefault: UserDefault) -> NSURL? {
        return URLForKey(userDefault.rawValue)
    }
    func setInteger(value: Int, forKey userDefault: UserDefault) {
        setInteger(value, forKey: userDefault.rawValue)
    }
    func setFloat(value: Float, forKey userDefault: UserDefault) {
        setFloat(value, forKey: userDefault.rawValue)
    }
    func setDouble(value: Double, forKey userDefault: UserDefault) {
        setDouble(value, forKey: userDefault.rawValue)
    }
    func setBool(value: Bool, forKey userDefault: UserDefault) {
        setBool(value, forKey: userDefault.rawValue)
    }
    func setURL(url: NSURL?, forKey userDefault: UserDefault) {
        setURL(url, forKey: userDefault.rawValue)
    }
    func registerDefaults(registrationDictionary: [UserDefault : AnyObject]) {
        registrationDictionary.mapPairs { tuple in (tuple.0.rawValue, tuple.1) }
    }
    func dictionaryRepresentation() -> [UserDefault: AnyObject] {
        return dictionaryRepresentation().mapPairs { tuple in (UserDefault(rawValue: tuple.0)!, tuple.1) }
    }
    func objectIsForcedForKey(userDefault: UserDefault) -> Bool {
        return objectIsForcedForKey(userDefault.rawValue)
    }
    func objectIsForcedForKey(userDefault: UserDefault, inDomain domain: String) -> Bool {
        return objectIsForcedForKey(userDefault.rawValue, inDomain: domain)
    }
}
// stolen from http://stackoverflow.com/a/24219069
extension Dictionary {
    private init(_ pairs: [Element]) {
        self.init()
        pairs.forEach { key, value in self[key] = value }
    }
    func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    func filterPairs(@noescape includeElement: Element throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }
}

extension UIImage {
    /// This sets image tint color to desired color.
    func imageWithTintColor(color: UIColor) -> UIImage? {
        var image = imageWithRenderingMode(.AlwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, image.scale);
        color.set()
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: image.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return  image
    }
}
// stolen from http://stackoverflow.com/a/26962452
extension UIDevice {
    // TODO: document, look into just using DeviceKit: https://github.com/dennisweissmann/DeviceKit if you end up needing this a lot
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return getDeviceType(identifier)
    }
    func getDeviceType(modelName: String) -> String {
        switch modelName {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "iOS Simulator"
        default:                                        return modelName
        }
    }
}
extension CollectionType {
    /// Returns the only element of `self`, or `nil` if `self` does not have *exactly* one element.
    ///
    /// - Complexity: O(1)
    var only: Self.Generator.Element? { return count == 1 ? first : nil }
    // TODO: replace places throughout the code when I use `.first` or `.last` semantics when I mean `.only`
}
// TODO: a global function doesn't belong here
func deviceIsSimulator() -> Bool {
    #if (arch(i386) || arch(x86_64)) && os(iOS)
        return true
    #else
        return false
    #endif
}
extension UIViewController {
    func addChildViewControllers(childControllers: [UIViewController]) {
        childControllers.forEach { childController in addChildViewController(childController) }
    }
}
extension UIView {
    var intrinsicContentSizeConstraints: [NSLayoutConstraint] {
        return constraints.filter { constraint in (constraint.firstAttribute == NSLayoutAttribute.Width || constraint.firstAttribute == NSLayoutAttribute.Height) && constraint.secondAttribute == NSLayoutAttribute.NotAnAttribute }
    }
}
extension SequenceType where Generator.Element: UIView {
    var constraints: [NSLayoutConstraint] {
        return flatMap { view in view.constraints }
    }
    var intrinsicContentSizeConstraints: [NSLayoutConstraint] {
        return flatMap { view in view.intrinsicContentSizeConstraints }
    }
}
public enum TextStyle {
    case Headline, Subheadline, Body, Footnote, Caption1, Caption2 // These mirror the UIFontTextStyles available in iOS 7+
    case Title1, Title2, Title3, Callout // These mirror the UIFontTextStyles available in iOS 9+
    case Body2, Title4, Title5 // These are custom UIFontTextStyles
}
extension UIFont {
    public class func preferredDzematFontForTextStyle(style: TextStyle) -> UIFont {
        var baseFontSize: CGFloat = 17
        
        // set `fontSize`
        // the default values mirror those for `UIFontTextStyleBody` at each of the different UIContentSizeCategories; other text styles should adjust appropriately
        switch UIApplication.sharedApplication().preferredContentSizeCategory {
        case UIContentSizeCategoryExtraSmall: baseFontSize = 14
        case UIContentSizeCategorySmall: baseFontSize = 15
        case UIContentSizeCategoryMedium: baseFontSize = 16
        case UIContentSizeCategoryLarge: baseFontSize = 17 // iOS defaults to UIContentSizeCategoryLarge
        case UIContentSizeCategoryExtraLarge: baseFontSize = 19
        case UIContentSizeCategoryExtraExtraLarge: baseFontSize = 21
        case UIContentSizeCategoryExtraExtraExtraLarge: baseFontSize = 23
        default: break
        }
        
        let minimumFontSize: CGFloat = 12
        
        // NOTE: font name != file name; use the font names below; refer here: http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/
        // Ubuntu-Italic
        // Ubuntu
        // Ubuntu-Bold
        // Ubuntu-BoldItalic
        // Ubuntu-MediumItalic
        // Ubuntu-Light
        // Ubuntu-Medium
        // Ubuntu-LightItalic
        
        // return the preferred Ade font for the provided `TextStyle`
        // the fonts returned closely mirror those returned by `UIFont.preferredFontForTextStyle(style: String) -> UIFont` which allows this method to default to an appropriately-sized system font in case the preferred Ade font is not available at runtime
        switch style {
        case .Headline:
            return UIFont(name: "Ubuntu-Medium", size: baseFontSize) ?? .systemFontOfSize(baseFontSize)
        case .Subheadline:
            let subheadlineFontSize = baseFontSize - 2
            return UIFont(name: "Ubuntu", size: subheadlineFontSize) ?? .systemFontOfSize(subheadlineFontSize)
        case .Body:
            return UIFont(name: "Ubuntu", size: baseFontSize) ?? .systemFontOfSize(baseFontSize)
        case .Footnote:
            let footnoteFontSize = max(baseFontSize - 4, minimumFontSize)
            return UIFont(name: "Ubuntu", size: footnoteFontSize) ?? .systemFontOfSize(footnoteFontSize)
        case .Caption1:
            let caption1FontSize = max(baseFontSize - 5, minimumFontSize)
            return UIFont(name: "Ubuntu", size: caption1FontSize) ?? .systemFontOfSize(caption1FontSize)
        case .Caption2:
            let caption2FontSize = max(baseFontSize - 6, minimumFontSize)
            return UIFont(name: "Ubuntu", size: caption2FontSize) ?? .systemFontOfSize(caption2FontSize)
        case .Title1:
            let title1FontSize = baseFontSize + 11
            return UIFont(name: "Ubuntu-Light", size: title1FontSize) ?? .systemFontOfSize(title1FontSize)
        case .Title2:
            let title2FontSize = baseFontSize + 5
            return UIFont(name: "Ubuntu", size: title2FontSize) ?? .systemFontOfSize(title2FontSize)
        case .Title3:
            let title3FontSize = baseFontSize + 3
            return UIFont(name: "Ubuntu", size: title3FontSize) ?? .systemFontOfSize(title3FontSize)
        case .Callout:
            let calloutFontSize = baseFontSize - 1
            return UIFont(name: "Ubuntu", size: calloutFontSize) ?? .systemFontOfSize(calloutFontSize)
        case .Body2:
            return UIFont(name: "Ubuntu-Light", size: baseFontSize) ?? .systemFontOfSize(baseFontSize)
        case .Title4:
            let title4FontSize = baseFontSize + 3
            return UIFont(name: "Ubuntu-Bold", size: title4FontSize) ?? .boldSystemFontOfSize(title4FontSize)
        case .Title5:
            let title5FontSize = baseFontSize + 6
            return UIFont(name: "Ubuntu-Bold", size: title5FontSize) ?? .boldSystemFontOfSize(title5FontSize)
        }
    }
}

// This extension provides properties for the standard `UIColor`s used throughout Ade.
// Before adding a new color, confirm that one of the ones already used cannot be reused.
// Any time a new color must be added, follow these steps:
// 1. create a new `@nonobjc static let` property
// 2. name it according to this [site]'s(http://www.htmlcsscolor.com ) suggestion; if the name overlaps another, consider using the original color (or add a postfix count)
// 3. set the property using the `UIColor` initializer which accepts a hex parameter
// 4. place it within the list alphabetically; @AndrewSelvia has a Swift script that will do this automatically
// 5. add a comment which follows the pattern set by other colors so that it's easy to quickly determine the color's visual appearance
extension UIColor {
    /// <http://www.htmlcsscolor.com/hex/63B054>
    @nonobjc static let apple = UIColor(netHex: 0x63B054)
    /// <http://www.htmlcsscolor.com/hex/000000>
    @nonobjc static let black = UIColor(netHex: 0x000000)
    /// <http://www.htmlcsscolor.com/hex/FFFFDD>
    @nonobjc static let ivory = UIColor(netHex: 0xFFFFDD)
    /// <http://www.htmlcsscolor.com/hex/86D072>
    @nonobjc static let pastelGreen = UIColor(netHex: 0x86D072)
    /// <http://www.htmlcsscolor.com/hex/5CA350>
    @nonobjc static let appleDark = UIColor(netHex: 0x5CA350)

}

//extension UILabel {
//    convenience init(translatesAutoresizingMaskIntoConstraints: Bool = true, font: UIFont, text: String = "", textAlignment: NSTextAlignment = .Center, textColor: UIColor = .black, numberOfLines: Int = 1) {
//        self.init(translatesAutoresizingMaskIntoConstraints: translatesAutoresizingMaskIntoConstraints)
//        self.font = font
//        self.text = text
//        self.textAlignment = textAlignment
//        self.textColor = textColor
//        self.numberOfLines = numberOfLines
//    }
//    
//    convenience init(translatesAutoresizingMaskIntoConstraints: Bool = false, attributedText: NSAttributedString, numberOfLines: Int = 1) {
//        self.init(translatesAutoresizingMaskIntoConstraints: translatesAutoresizingMaskIntoConstraints)
//        self.attributedText = attributedText
//        self.numberOfLines = numberOfLines
//    }
//}

extension NSDate {
    static var oneMinuteFromNow: NSDate {
        return NSDate().dateByAddingTimeInterval(.minute)
    }
}

extension NSTimeInterval {
    static let minute = NSTimeInterval(60)
}

extension CollectionType {
    /// Returns `true` iff `self` is not empty.
    ///
    /// - Complexity: O(1)
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension RangeReplaceableCollectionType where Index: BidirectionalIndexType {
    mutating func leftRotated() {
        append(removeFirst())
    }
    
    mutating func rightRotated() {
        insert(removeLast(), atIndex: startIndex)
    }
}

extension UIViewController {
    var backViewController: UIViewController? {
        guard let navigableViewControllers = self.navigationController?.viewControllers,
            precedingViewControllerIndex = navigableViewControllers.indices.last?.predecessor()
            else { return nil }
        return navigableViewControllers[precedingViewControllerIndex]
    }
}

extension UITableView {
    func setDefaultTable() {
    
    }
}

extension UITableViewCell {
    func removeSeparatorFromCell() {
        //Found answer here to hide cells separator, but will need to adjust this a little bit http://stackoverflow.com/questions/8561774/hide-separator-line-on-one-uitableviewcell
        let indent_large_enought_to_hidden:CGFloat = 10000
        separatorInset = UIEdgeInsetsMake(0, indent_large_enought_to_hidden, 0, 0) // indent large engough for separator(including cell' content) to hidden separator
        indentationWidth = indent_large_enought_to_hidden * -1 // adjust the cell's content to show normally
        indentationLevel = 1 // must add this, otherwise default is 0, now actual indentation = indentationWidth * indentationLev
    }
}

extension JVFloatLabeledTextField {
    func defaultSetting () {
        floatingLabelTextColor = UIColor.whiteColor()
        floatingLabelActiveTextColor = UIColor.whiteColor()
        floatingLabelFont = UIFont.preferredDzematFontForTextStyle(.Footnote)
        floatingLabelActiveTextColor = .whiteColor()
        textColor = .whiteColor()
        textFont = UIFont.preferredDzematFontForTextStyle(.Body)
       
        
    }
}