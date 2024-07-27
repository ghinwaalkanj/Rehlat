import { createSlice } from "@reduxjs/toolkit";
import {
  setCookie,
  getCookie,
  eraseCookie,
  deleteCookie,
} from "../utils/helperFunction";

const token = getCookie("token");
const d_token = getCookie("d_token");
const initialState = {
  mode: "dark",
  user: null,
  token: token ? token : null,
  d_token: d_token ? d_token : null,
};

export const globalSlice = createSlice({
  name: "global",
  initialState,
  reducers: {
    setMode: (state) => {
      state.mode = state.mode === "light" ? "dark" : "light";
    },
    setLogin: (state, action) => {
      state.user = action.payload.user;
      state.token = action.payload.token;
    },
    setLogout: (state) => {
      eraseCookie("token");
      eraseCookie("user");
      eraseCookie("d_token");
      eraseCookie("username");
      eraseCookie("name_ar");
      deleteCookie("token");
      deleteCookie("user");
      deleteCookie("d_token");
      deleteCookie("username");
      deleteCookie("name_ar");
      state.user = null;
      state.token = null;
      state.d_token = null;
    },
    setDLogin: (state, action) => {
      state.user = action.payload.user;
      state.d_token = action.payload.token;
    },
  },
});

export const { setMode, setLogin, setLogout, setDLogin } = globalSlice.actions;

export default globalSlice.reducer;
