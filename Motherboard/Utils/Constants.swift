//
//  Constants.swift
//  Motherboard
//
//  Created by Wanhar on 25/11/25.
//

struct Constants {
    
    // MARK: - App
    static let appName = "Motherboard"
    static let getStarted = "Get Started"
    
    // MARK: - Login
    static let login = "Login"
    static let register = "Register"
    static let email = "Email"
    static let emailAddress = "Email Address"
    static let fullName = "Full Name"
    static let password = "Password"
    static let confirmPassword = "Confirm Password"
    static let createAccount = "Create account"
    static let registerTitle = "Let's get you started"
    static let registerSubtitle = "Set up your profile in less than a minute."
    static let orSignUpWith = "Or Sign Up With"
    static let enterEmail = "Enter your email"
    static let enterPassword = "Enter your password"
    static let enterFullname = "Enter your full name"
    static let enterConfirmPassword = "Confirm your password"
    
    // MARK: - Alerts
    static let error = "Error"
    static let ok = "OK"
    static let errorOccurred = "An error occurred"
    
    // MARK: - Validation Messages
    static let fillAllFields = "Please fill in all fields"
    static let validEmail = "Please enter a valid email address"
    static let passwordDoNotMatch = "Passwords do not match"
    static let passwordTooShort = "Password must be at least 6 characters"
    
    // MARK: - Home Screen
    static let todaysSchedule = "Today's Schedule"
    static let kids = "Kids"
    static let upcoming = "Upcoming"
    static let shareSitterSheet = "Share sitter sheet"
    
    // MARK: - Add Child
    static let addChild = "Add Child"
    static let fullname = "Full Name"
    static let nickname = "Nickname"
    static let dateOfBirth = "Date of Birth"
    static let gender = "Gender"
    static let notes = "Notes"
    static let photo = "Photo"
    static let male = "Male"
    static let female = "Female"
    static let save = "Save"
    static let enterNickname = "Enter nickname"
    static let enterNotes = "Enter notes (optional)"
    
    // MARK: - Error Messages
    static let noUserIDAvailable = "No user ID available"
    static let failedToGetImageURL = "Failed to get image URL after upload"
    static let pleaseEnterFullname = "Please enter full name"
    static let pleaseEnterNickname = "Please enter nickname"
    
    // MARK: - Messages
    static let howWouldYouLikeToUseMotherboard = "How Would You Like to Use Motherboard?"
    static let selectARole = "Select the role that aligns with how you intend to use the app."
    
    // MARK: - Onboarding Add Child
    static let addYourChild = "Add your child"
    static let addDetailsAboutYourChildToContinue = "Add details about your child to continue."
    static let childsName = "Childs Name:"
    static let placeholder = "Placeholder"
    static let dateOfBirthLabel = "Date of Birth:"
    static let dateFormatPlaceholder = "MM/DD/YYYY"
    static let genderLabel = "Gender:"
    static let childsImage = "Childs Image:"
    static let uploading = "Uploading..."
    static let removePhoto = "Remove Photo"
    static let please = "Please, "
    static let tapToUpload = "tap to upload"
    static let yourChildsPicture = "your child's picture"
    static let or = "Or"
    static let openCamera = "Open Camera"
    static let done = "Done"
    
    // MARK: - Health & Medical Information
    static let healthMedicalInfoTitle = "Health & Medical Information"
    static let healthMedicalInfoSubtitle = "Provide information on allergies, medications, and medical conditions"
    static let allergies = "Allergies"
    static let allergyName = "Allergy Name:"
    static let severity = "Severity:"
    static let triggerDetails = "Trigger details"
    static let reactionDescription = "Reaction description"
    static let specificInstructions = "Specific instructions for caregiver"
    static let skipForNow = "Skip for Now"
    static let typeInformationOnTriggerDetails = "Type information on trigger details"
    static let typeInformationOnReactionDescription = "Type information on reaction description"
    static let exampleInstructions = "e.g., \"Avoid dairy completely,\" etc."
    
    // MARK: - Medical Conditions
    static let medicalConditions = "Medical Conditions"
    static let conditionName = "Condition Name:"
    static let description = "Description"
    static let doctorsInstructions = "Doctors instructions"
    static let startDate = "Start date?"
    static let ongoing = "Ongoing"
    static let giveMoreInformationOnConditionDescription = "Give more information on the condition description"
    static let provideInformationOnDoctorsInstructions = "Provide information on doctors instructions"
    static let enterConditionsStartDate = "Enter conditions start date"
    
    // MARK: - Medications
    static let medications = "Medications"
    static let medicationName = "Medication name:"
    static let dose = "Dose"
    static let route = "Route"
    static let frequency = "Frequency"
    static let timeSchedule = "Time schedule"
    static let startDateString = "Start date"
    static let endDateOptional = "End date (optional)*"
    static let doctorsNote = "Doctors Note"
    static let enterTimeframe = "Enter a timeframe"
    static let kindlyProvideInformationOnStartDate = "Kindly provide information on start date"
    static let provideInformationOnDoctorsNote = "Provide information on doctors note"
    static let pictureOfMedicationBottle = "picture of medication bottle (optional)*"
    
    // MARK: - Emergency Medication
    static let epipenEmergencyMedicationInstructions = "EpiPen / Emergency Medication Instructions"
    static let autoInjectorBrand = "Auto-injector brand"
    static let whenToAdminister = "When to administer"
    static let followUpSteps = "Follow up steps"
    static let instructionalYouTubeLink = "Instructional YouTube link"
    static let doctorContact = "Doctor contact"
    static let forAnaphylaxisSigns = "e.g., \"For anaphylaxis signs...\""
    static let call911 = "e.g, call 911, etc."
    static let enterLinkURL = "Enter link URL"
    static let kindlyProvideDoctorsContact = "Kindly provide doctors contact"

    static let pediatricianSpecialistInformation = "Pediatrician / Specialist Information"
    static let doctorName = "Doctor name"
    static let practiceName = "Practice name"
    static let phone = "Phone"
    static let address = "Address"
    static let portalLinkOptional = "Portal link (optional)*"
    
    static let bottlesAndMeals = "Bottles & Meals"
    static let breastfeedingAndPumping = "Breastfeeding & Pumping"
    static let routines = "Routines"
    static let bottlesAndMealsDescription = "Feeding times, bottles, meal reminders"
    static let medicationsRoutineDescription = "Schedule doses and reminders"
    static let diapersDescription = "Track diapers changes"
    static let breastfeedingAndPumpingDescription = "Manage breastfeeding sessions & pumping cycles"
    static let createACustomRoutine = "Create a custom routine"
    static let proceed = "Proceed"
    static let diapers = "Diapers"
    static let chooseTheRoutinesYouWantToSetUp = "Choose the routines you want to set up"
    static let youCanSelectOneOrMultipleRoutines = "You can select one or multiple routines."
    
    // MARK: - Common
    static let skip = "Skip"
    static let next = "Next"
    static let alreadyHaveAnAccount = "Already have an account?"
    static let dontHaveAnAccountYet = "Don’t have an account yet?"
    static let logIn = "Log In"
    static let signUpHere = "Sign Up here"
    static let continueString = "Continue"
    static let forgotPassword = "Forgot password?"
    static let resetYourPassword = "Reset your password"
    static let enterEmailAssociatedWithAccount = "Enter the email associated with your account."
    static let resetPassword = "Reset Password"
    static let success = "Success"
    static let emailVerification = "Email verification"
    static let checkYourInbox = "Check your inbox"
    static let passwordResetLinkSent = "We've sent a password reset link to your email. Follow the instructions to create a new password."
    static let didntReceiveEmail = "Didn't receive the email?"
    static let resendCode = "Resend code"
    static let passwordResetEmailHasBeenSent = "Password reset email has been sent. Please check your inbox."
    
    // MARK: - Message
    static let kidIDNotAvailable = "Kid ID is not available"
    static let pleaseSelectARole = "Please select a role"
    static let welcomeBack = "Welcome Back"
    static let accessYourDashboardAndRoutines = "Access your dashboard and routines."
    static let orContinueWith = "Or continue with"
    static let passwordResetEmailHasBeenSent = "Password reset email has been sent. Please check your inbox."
}
