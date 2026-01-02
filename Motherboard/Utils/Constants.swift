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

    // MARK: - Auth (Login / Register)
    static let login = "Login"
    static let register = "Register"
    static let createAccount = "Create account"
    static let logIn = "Log In"

    static let email = "Email"
    static let emailAddress = "Email Address"
    static let fullName = "Full Name"
    static let password = "Password"
    static let confirmPassword = "Confirm Password"

    static let enterEmail = "Enter your email"
    static let enterPassword = "Enter your password"
    static let enterFullname = "Enter your full name"
    static let enterConfirmPassword = "Confirm your password"

    static let registerTitle = "Let's get you started"
    static let registerSubtitle = "Set up your profile in less than a minute."
    static let orSignUpWith = "Or Sign Up With"

    static let alreadyHaveAnAccount = "Already have an account?"
    static let dontHaveAnAccountYet = "Don’t have an account yet?"
    static let signUpHere = "Sign Up here"
    static let orContinueWith = "Or continue with"

    static let welcomeBack = "Welcome Back"
    static let accessYourDashboardAndRoutines = "Access your dashboard and routines."

    // MARK: - Password Reset & Verification
    static let forgotPassword = "Forgot password?"
    static let resetYourPassword = "Reset your password"
    static let enterEmailAssociatedWithAccount = "Enter the email associated with your account."
    static let resetPassword = "Reset Password"

    static let emailVerification = "Email verification"
    static let checkYourInbox = "Check your inbox"

    static let passwordResetLinkSent = "We've sent a password reset link to your email. Follow the instructions to create a new password."
    static let didntReceiveEmail = "Didn't receive the email?"
    static let resendCode = "Resend code"
    static let passwordResetEmailHasBeenSent = "Password reset email has been sent. Please check your inbox."

    static let changePassword = "Change Password"
    static let createNewPassword = "Create new password"
    static let enterNewPasswordDescription = "Enter your new password below."
    static let newPassword = "New Password"
    static let enterNewPassword = "Enter your new password"

    static let passwordUpdatedSuccessfully = "Password Updated Successfully"
    static let pleaseLoginWithNewPassword = "Please login with your new password."
    static let continueToLogin = "Continue to Login"

    // MARK: - Alerts
    static let error = "Error"
    static let success = "Success"
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

    // MARK: - Role Selection
    static let howWouldYouLikeToUseMotherboard = "How Would You Like to Use Motherboard?"
    static let selectARole = "Select the role that aligns with how you intend to use the app."
    static let pleaseSelectARole = "Please select a role"

    // MARK: - Add Child
    static let addChild = "Add Child"
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

    static let pleaseEnterFullname = "Please enter full name"
    static let pleaseEnterNickname = "Please enter nickname"

    // MARK: - Errors
    static let noUserIDAvailable = "No user ID available"
    static let failedToGetImageURL = "Failed to get image URL after upload"

    // MARK: - Messages
    static let kidIDNotAvailable = "Kid ID is not available"

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
    static let addMedicationRoutine = "Add Medication Routine"
    static let addMedicationMessage = "Set up how and when this medication should be given."

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

    // MARK: - Routines
    static let routines = "Routines"
    static let bottlesAndMeals = "Bottles & Meals"
    static let breastfeedingAndPumping = "Breastfeeding & Pumping"
    static let diapers = "Diapers"

    static let bottlesAndMealsDescription = "Feeding times, bottles, meal reminders"
    static let medicationsRoutineDescription = "Schedule doses and reminders"
    static let diapersDescription = "Track diapers changes"
    static let breastfeedingAndPumpingDescription = "Manage breastfeeding sessions & pumping cycles"

    static let createACustomRoutine = "Create a custom routine"
    static let proceed = "Proceed"
    static let chooseTheRoutinesYouWantToSetUp = "Choose the routines you want to set up"
    static let youCanSelectOneOrMultipleRoutines = "You can select one or multiple routines."
    static let yourRoutines = "Your Routines"
    static let manageScheduledRoutines = "Manage Scheduled routines"
    static let manageDailyRoutines = "Create and manage your child’s daily routines."
    static let enterRoutineTitle = "Enter routine title"
    static let mealSchedule = "Meal schedule"
    static let selectInfoBelow = "Select the appropriate information below"
    static let mealName = "Meal Name"
    static let mealTime = "Meal time"
    static let addCustomTime = "+ Add custom time"
    static let feedingInstructionsNotes = "Feeding Instructions notes"
    static let feedingInstructionsPlaceholder = "E.g, Mashed potatoes and boiled carrots by 9am."
    static let feedingNotesPlaceholder = "E.g, Give detailed note on when to feed baby and proper ounces/mL with specific times"
    static let bottleSchedule = "Bottle schedule"
    static let bottlingTime = "Bottling time"
    static let bottlingNotes = "Bottling Instructions notes"
    static let howOftenShouldThisRepeat = "How often Should this repeat?"
    static let selectCustomDay = "Select Custom Day"
    static let createRoutine = "Create routine"
    static let ouncesmL = "Ounces/mL"
    static let instructionsDiapers = "Diapers Instructions notes"
    static let instructionsBreast = "Breast feeding Instructions notes"
    static let diapersInstructionsPlaceholder = "Please kindly provide instructions on how to use diapers"
    static let breastInstructionsPlaceholder = "E.g, Ensure to breastfeed Sonia by 9:00am prompt."
    static let breastfeedingSchedule = "Breastfeeding Schedule"
    static let breast = "Breast"
    static let breastFeedingTime = "Breast feeding time"
    static let pumpingSchedule = "Pumping Schedule"
    static let pumping = "Pumping"
    static let pumpingTime = "Pumping time"
    static let pumpingInstructionsNotes = "Pumping Instructions notes"
    static let pumpingInstructionsPlaceholder = "E.g, Ensure to pump Sonia by 9:00am prompt."
    
    // MARK: - Empty State
    static let noRoutinesAddedYet = "No routines added yet"
    static let createRoutinesDescription = "Create routines to help your caregiver follow your child's daily structure."

    // MARK: - Common
    static let skip = "Skip"
    static let next = "Next"
    static let welcome = "Welcome"
    static let continueString = "Continue"
    static let typeString = "Type"
    static let timeString = "Time"
    static let errorString = "Error"
    static let okString = "Ok"
}
