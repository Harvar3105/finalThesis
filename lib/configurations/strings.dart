import 'package:flutter/foundation.dart';

@immutable
class Strings {
  // General app information
  static const appName = 'Itemy';
  static const welcomeToAppName = 'Welcome to ${Strings.appName}';
  static const loading = "Loading...";
  static const addOrder = 'Create a new order';

  // Menu
  static const menu = 'Menu';
  static const search = 'Search';
  static const profile = 'Profile';
  static const shop = 'Shop';
  static const toShop = 'To shop';
  static const chats = 'Chats';

  // Add order views
  static const addPostView = 'Add order';
  static const tradeAvailable = 'Trade available';
  static const saveOrder = 'Save order!';

  // Edit order views
  static const editOrder = 'Edit order';
  static const updateOrder = 'Update order!';

  // Address
  static const selectLocation = 'Select a location!';
  static const confirmLocation = 'Confirm location!';

  // Order
  static const name = 'Name';
  static const description = 'Description';
  static const price = 'Price';
  static const hintPrice = '\$0.00 or \$0,00';
  static const tags = 'Tags';
  static const hintTags = 'Example: one,two,three';
  static const seller = 'Seller: ';
  static const tradeAccept = 'The owner accepts price discussions!';
  static const tradeDecline = 'The owner does not accept price discussions!';
  static const contactSeller = 'Contact seller!';
  static const noOrders = 'Sorry, no orders found :(';

  // Dialogs
  static const logOut = 'Log Out';
  static const notLoggedIn = 'User is not logged in :(';
  static const areYouSureThatYouWantToLogOutOfTheApp =
      'Are you sure that you want to log out of the app? :(';
  static const cancel = 'Cancel';
  static const delete = 'Delete';
  static const areYouSureYouWantToDeleteThis =
      'Are you sure you want to delete this';
  static const comment = 'Comment';
  static const tagsInput = 'Enter tags separated by commas';
  static const hintTagsInput = 'Example: iphone,android,nike,orange';
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
  static const username = 'Username';

  // Name and photo related strings
  static const updateSuccess = 'Name and photo updated successfully!';
  static const photoDeleteSuccess = 'Photo deleted successfully';
  static const changeNameAndPhoto = 'Change Name & Photo';
  static const pfp = 'Profile picture:';
  static const newName = 'New Name';
  static const nameIsRequired = 'Name is required!';
  static const save = 'Save';

  // Private constructor to prevent instantiation
  const Strings._();
}
