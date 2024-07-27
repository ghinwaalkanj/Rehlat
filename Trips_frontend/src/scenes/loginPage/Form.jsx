import { useState } from "react";
import {
  Box,
  Button,
  TextField,
  useMediaQuery,
  Typography,
  useTheme,
} from "@mui/material";
import { toast } from "react-toastify";

import { Formik } from "formik";
import * as yup from "yup";
import { useNavigate } from "react-router-dom";
import { useDispatch } from "react-redux";
import { setLogin } from "state";
import {
  setCookie,
  getCookie,
  eraseCookie,
  deleteCookie,
} from "../../utils/helperFunction";

const loginSchema = yup.object().shape({
  username: yup
    .string()
    .required("required")
    .matches(/^[a-zA-Z0-9@#$%^.&*]+$/, "يجب أن يحتوي على أحرف انكليزية  فقط"),
  password: yup.string().required("required"),
});

const initialValuesLogin = {
  username: "",
  password: "",
};

const Form = () => {
  const { palette } = useTheme();
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const isNonMobile = useMediaQuery("(min-width:600px)");

  const login = async (values, onSubmitProps) => {
    const loggedInResponse = await fetch(
      process.env.REACT_APP_BASE_URL + "companies/login",
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(values),
      }
    );

    if (loggedInResponse.status === 402) {
      // Handle incorrect email or password error
      toast.error("Incorrect username or password");
      return;
    }
    if (loggedInResponse.status === 403) {
      // Handle incorrect email or password error
      toast.error("هذا الحساب متوقف حالياََ");
      return;
    }

    if (loggedInResponse.ok) {
      const loggedIn = await loggedInResponse.json();

      // localStorage.setItem("token", loggedIn.token);
      // localStorage.setItem("image", loggedIn.data.logo);
      // localStorage.setItem("name_ar", loggedIn.data.name_ar);

      // sessionStorage.setItem("token", loggedIn.token);
      // sessionStorage.setItem("image", loggedIn.data.logo);
      // sessionStorage.setItem("name_ar", loggedIn.data.name_ar);

      setCookie("token", loggedIn.token, 5);
      setCookie("image", loggedIn.data.logo, 5);
      setCookie("name_ar", loggedIn.data.name_ar, 5);

      eraseCookie("d_token");

      // localStorage.setItem("name_ar", loggedIn.name_ar);

      dispatch(
        setLogin({
          user: loggedIn.data,
          token: loggedIn.token,
        })
      );
      toast.success("login successfully");
      onSubmitProps.resetForm();
      navigate("/dashboard");
    }
  };

  const handleFormSubmit = async (values, onSubmitProps) => {
    await login(values, onSubmitProps);
  };

  return (
    <Formik
      onSubmit={handleFormSubmit}
      initialValues={initialValuesLogin}
      validationSchema={loginSchema}
    >
      {({
        values,
        errors,
        touched,
        handleBlur,
        handleChange,
        handleSubmit,
        setFieldValue,
        resetForm,
      }) => (
        <form onSubmit={handleSubmit}>
          <Box
            display="grid"
            gap="30px"
            gridTemplateColumns="repeat(4, minmax(0, 1fr))"
            sx={{
              "& > div": { gridColumn: isNonMobile ? undefined : "span 4" },
            }}
          >
            <TextField
              label="Username"
              onBlur={handleBlur}
              onChange={handleChange}
              value={values.username}
              name="username"
              error={Boolean(touched.username) && Boolean(errors.username)}
              helperText={touched.username && errors.username}
              sx={{ gridColumn: "span 4" }}
            />

            <TextField
              label="Password"
              type="password"
              autoComplete="off"
              onBlur={handleBlur}
              onChange={handleChange}
              value={values.password}
              name="password"
              error={Boolean(touched.password) && Boolean(errors.password)}
              helperText={touched.password && errors.password}
              sx={{ gridColumn: "span 4" }}
            />
          </Box>

          {/* BUTTONS */}
          <Box>
            <Button
              fullWidth
              type="submit"
              sx={{
                m: "2rem 0",
                p: "1rem",
                backgroundColor: palette.secondary[50],
                color: palette.background.alt,
                "&:hover": { color: palette.secondary[50] },
              }}
            >
              {"LOGIN"}
            </Button>
          </Box>
        </form>
      )}
    </Formik>
  );
};

export default Form;
