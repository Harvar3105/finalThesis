import 'package:flutter/foundation.dart';

@immutable
class Strings {
  // General app information
  static const appName = 'App Name'; //TODO: Change this to your app name
  static const welcomeToAppName = 'Welcome to ${Strings.appName}';
  static const loading = "Loading...";

  // Pages
  static const menu = 'Menu';
  static const search = 'Search';
  static const profile = 'Profile';
  static const main = 'Main page';
  static const home = 'Home';
  static const chats = 'Chats';
  static const calendar = 'Calendar';
  static const myCalendar = 'My Calendar';
  static const friends = 'Friends';
  static const registerPage = 'Register';
  static const loginPage = 'Login';
  static const dayView = 'Day View';

  // Address
  static const selectLocation = 'Select a location!';
  static const confirmLocation = 'Confirm location!';


  // Dialogs
  static const logOut = 'Log Out';
  static const notLoggedIn = 'User is not logged in :(';
  static const areYouSureThatYouWantToLogOutOfTheApp =
      'Are you sure that you want to log out of the app? :(';
  static const cancel = 'Cancel';
  static const delete = 'Delete';
  static const areYouSureYouWantToDeleteThis =
      'Are you sure you want to delete this';
  static const ok = 'OK';
  static const errLoadingChats = 'Error loading chats :(';

  // Third-party integration
  static const google = 'Google';
  static const googleSignupUrl = 'https://accounts.google.com/signup';

  // Login and account-related messages
  static const logIntoYourAccount = 'Log into your account.';
  static const dontHaveAnAccount = "Don't have an account?\n";
  static const signUp = 'Sign up';
  static const login = "Log in";
  static const register = 'Register';
  static const orCreateAnAccountOn = ' or create an account on ';
  static const confirmationLink = 'Confirmation link has been sent to email!';
  static const failedEmailChange = 'Failed to change email :(';
  static const tooManyAttempts = 'Too many attempts! Please try again later...';
  static const changeEmail  =  'Change Email';
  static const changePassword = 'Change Password';
  static const password = 'Password';
  static const oldPassword = 'Old Password';
  static const newPassword = 'New Password';
  static const confirmNewPassword = 'Confirm New Password';
  static const passwordMismatch = 'Passwords do not match';
  static const wrongEmailOrPassword = 'Wrong email or password!';
  static const newEmail = 'New Email';
  static const email = 'Email';
  static const passChangedSuccess = 'Password changed successfully';
  static const passChangeFailed = 'Failed to change password :(';
  static const userProfile = 'User Profile';
  static const userExists = 'User already exists!';
  static const firstName = 'First name';
  static const lastName = 'Last name';

  // Name and photo related strings
  static const updateSuccess = 'Name and photo updated successfully!';
  static const photoDeleteSuccess = 'Photo deleted successfully';
  static const changeNameAndPhoto = 'Change Name & Photo';
  static const pfp = 'Profile picture:';
  static const newFirstName = 'New first name';
  static const newLastName = 'New last name';
  static const nameIsRequired = 'Name is required!';
  static const save = 'Save';

  // Private constructor to prevent instantiation
  const Strings._();
}
