import 'package:flutter/material.dart';

Pattern emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

// const SecondaryColor = Color(0xFF7f53fd);
// const PrimaryColor = Color(0xFF4ea1fd);

const SecondaryColor = Color(0xFFa34ee6);
const PrimaryColor = Color(0xFFa34ee6);

const TabActiveColor = Color(0xFFe7d5f5);

const List<Color> colors = [PrimaryColor, SecondaryColor];
const List<double> stops = [0.0, 0.7];

const CONFIG_URL = "https://core.projuktipl.com/api/";
const BASE_URL = CONFIG_URL + "consumer/";
const SIGN_UP_URL = BASE_URL + 'auth/register';
const SIGN_IN_URL = BASE_URL + 'auth/login';
const SIGN_OUT = BASE_URL + 'auth/logout';
const CHANGE_PASSWORD = BASE_URL + 'auth/change-password';
const RESEND_VERIFICATION_EMAIL = BASE_URL + 'auth/resend-verification-mail';
const UPDATE_PROFILE = BASE_URL + 'profile/update-my-profile-details';
// const GET_LOCATIO0N_BY_ZIP_CODE =
//     CONFIG_URL + 'common/location/get-location-by-zip-code';
const GET_ALL_CATEGORIES = BASE_URL + 'product/category/get-all-categories';
const GET_SUB_CATEGORY =
    BASE_URL + 'product/sub-category/get-all-sub-categories';

const GET_LOCATIO0N_BY_ZIP_CODE =
    CONFIG_URL + 'common/location/get-location-by-zip-code';
const ADD_ADDRESS = BASE_URL + "profile/add-address";
const GET_ALL_ADDRESS = BASE_URL + "profile/get-addresses";
const SET_DEFAULT_ADDRESS = BASE_URL + "profile/change-default-address";
const DELETE_ADDRESS = BASE_URL + "profile/delete-address";
const EDIT_ADDRESS = BASE_URL + "profile/update-address";
const GET_HOME_DATA_URL = BASE_URL + "get-home-page";
const GET_ALL_PRODUCTS = BASE_URL + 'product/products/get-all-products';
const GET_ALL_BRANDS = BASE_URL + 'product/brand/get-all-brands';
const GET_ALL_COLORS =
    BASE_URL + 'product/product-color/get-all-product-colors';
const GET_ALL_SIZES = BASE_URL + 'product/product-size/get-all-product-sizes';
const GET_PRODUCT_DETAILS = BASE_URL + 'product/products/get-a-product/';
const ADD_TO_CART = BASE_URL + 'product/orders/add-to-cart';
const GET_CART_ITEMS = BASE_URL + 'product/orders/get-from-cart';
