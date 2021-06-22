struct UserDefaultVars {
    static var mpin = UserDefaults.standard.value(forKey: "mpin") as! String
    static var designation = UserDefaults.standard.value(forKey: "DESIGNATION") as! String
    static var empName = UserDefaults.standard.value(forKey: "EMP_NAME") as! String
    static var typeId = UserDefaults.standard.value(forKey: "TYPE_ID") as! String
    static var mobileNumber = UserDefaults.standard.value(forKey:"MOBILE_NO") as! String
    static var empId = UserDefaults.standard.value(forKey:"EMP_D") as! String
    static var grievanceType =  UserDefaults.standard.value(forKey:"grievanceType") as! String
    static var modeID =  UserDefaults.standard.value(forKey:"MODEID") as! String
    static var subcatId =  UserDefaults.standard.value(forKey:"SUBCAT_ID") as! String
    static var token =  UserDefaults.standard.value(forKey:"TOKEN_ID") as! String
    
    
    
}
let userid = "cgg@ghmc"
let password = "ghmc@cgg@2018"
//messages
let interNetconnection = "Please check InternetConnection"

//loginviewcontroller
let progressMsgWhenLOginClicked = "Loading.."
let enterPHoneNumber = "Please enter PhoneNumber"

//mpin viewcontroller
let  mpinValidate = "MpinValidated SuccesFully"
let  mpinvalidatefail = "Please enter correct MPIN"

//otp viewcontroller
let otpnil = "Please enter Otp"
let otpIncorrect = "Please enter Correct Otp"
let validationSuccessFully = "validated successfully"

//update Mpin
let enterMpin = "Please enter MPIN"
let RenterMpin = "Please Re_enter MPIN"
let incorrectMpin = "Please enter Same MPIN"
//home screen
let datanotAvaliable = "Data not avalibale this time"
//take action view controller
let failedupdate =  "Failed to update please tryAgain Later"
let complaint = "please select complaintType"
let ward = "Please select ward"
let imageError = "please upload image"

let deviceId = UIDevice.current.identifierForVendor!.uuidString

let trAagin = "Try Aagin"
let serverNotResponding = "Server not responding Please try again later!"
let noInternet = "No network connectivity found, please check your internet connection"
    let firstColour = UIColor.init(red:115/255 , green:198/255, blue:182/255, alpha:1.0)
    let secondColour = UIColor.init(red:12/255, green:179/255, blue: 213/255, alpha:1.0)
    let thirdColour = UIColor.init(red:230/255, green: 176/255, blue: 170/255, alpha:1.0)
    let fourthColour = UIColor.init(red:245/255, green: 203/255, blue: 167/255, alpha:1.0)
    let fifthColour = UIColor.init(red:214/255, green: 219/255, blue:223/255, alpha:1.0)
    let sixthColour = UIColor.init(red:215/255, green: 189/255, blue:226/255, alpha:1.0)
    
private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}
