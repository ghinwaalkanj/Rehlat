import {
  Box,
  Button,
  Checkbox,
  FormControl,
  FormControlLabel,
  InputLabel,
  MenuItem,
  Select,
  TextField,
  Typography,
  useMediaQuery,
  useTheme,
} from "@mui/material";
import { Formik } from "formik";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DatePicker, LocalizationProvider } from "@mui/x-date-pickers";
import Dropzone from "react-dropzone";
import EditOutlinedIcon from "@mui/icons-material/EditOutlined";
import * as yup from "yup";
import React from "react";
import { useAddCompanyMutation } from "state/api";

import dayjs from "dayjs";
import { useTranslation } from "react-i18next";
import { toast } from "react-toastify";
import FlexBetween from "components/FlexBetween";
import { useNavigate } from "react-router-dom";
const AddCompany = () => {
  const { palette } = useTheme();
  const [t, i18n] = useTranslation();

  const initialValuesRegister = {
    name_ar: "",
    name_en: "",
    username: "",
    password: "",
    logo: "",
  };
  const registerSchema = yup.object().shape({
    name_ar: yup.string().required("required"),
    name_en: yup.string().required("required"),
    username: yup
      .string()
      .required("required")
      .matches(/^[a-zA-Z0-9@#$%^.&*]+$/, "يجب أن يحتوي على أحرف انكليزية  فقط"),
    password: yup
      .string()
      .required("required")
      .matches(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/,
        " يجب ان تحتوي على أحرف كبيرة وأحرف صغيرة وأرقام ورموز مثل @ # ويجب أن لا تقل عن 8 محارف"
      ),
    logo: yup.string().required("required"),
  });
  const [createCompany, { isSuccess, isError, error }] =
    useAddCompanyMutation();

  const isNonMobile = useMediaQuery("(min-width:600px)");

  const navigate = useNavigate();

  const handleFormSubmit = async (values, onSubmitProps) => {
    console.log("values", values);

    await createCompany(values);
    // console.log('eee',error);
    // if (error) {
    //   toast.error("Fail! please try again");
    // } else {
    toast.success("Success!");
    // }

    onSubmitProps.resetForm();
    // navigate(-1);
  };

  return (
    <div>
      <Box m="6rem">
        <Formik
          onSubmit={handleFormSubmit}
          initialValues={initialValuesRegister}
          validationSchema={registerSchema}
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
              {console.log("values", values)}
              <Box
                display="grid"
                gap="30px"
                width="80%"
                mx="auto"
                gridTemplateColumns="repeat(4, minmax(0, 1fr))"
                sx={{
                  "& > div": { gridColumn: isNonMobile ? undefined : "span 4" },
                }}
              >
                {
                  <>
                    {/*  */}
                    <TextField
                      label="الاسم بالعربي"
                      onBlur={handleBlur}
                      onChange={handleChange}
                      value={values.name_ar}
                      name="name_ar"
                      error={
                        Boolean(touched.name_ar) && Boolean(errors.name_ar)
                      }
                      helperText={touched.name_ar && errors.name_ar}
                      sx={{ gridColumn: "span 2" }}
                    />
                    <TextField
                      label="الاسم بالانجليزي "
                      onBlur={handleBlur}
                      onChange={handleChange}
                      value={values.name_en}
                      name="name_en"
                      error={
                        Boolean(touched.name_en) && Boolean(errors.name_en)
                      }
                      helperText={touched.name_en && errors.name_en}
                      sx={{ gridColumn: "span 2" }}
                    />
                    <TextField
                      label=" اسم المستخدم  "
                      onBlur={handleBlur}
                      onChange={handleChange}
                      value={values.username}
                      name="username"
                      error={
                        Boolean(touched.username) && Boolean(errors.username)
                      }
                      helperText={touched.username && errors.username}
                      sx={{ gridColumn: "span 4" }}
                    />
                    <TextField
                      label=" كلمة السر  "
                      onBlur={handleBlur}
                      onChange={handleChange}
                      type="password"
                      autoComplete="off"
                      value={values.password}
                      name="password"
                      error={
                        Boolean(touched.password) && Boolean(errors.password)
                      }
                      helperText={touched.password && errors.password}
                      sx={{ gridColumn: "span 4" }}
                    />
                    <Box
                      gridColumn="span 4"
                      border={`1px solid ${palette.neutral.medium}`}
                      borderRadius="5px"
                      p="1rem"
                    >
                      <Dropzone
                        acceptedFiles=".jpg,.jpeg,.png"
                        multiple={false}
                        onDrop={(acceptedFiles) =>
                          setFieldValue("logo", acceptedFiles[0])
                        }
                      >
                        {({ getRootProps, getInputProps }) => (
                          <Box
                            {...getRootProps()}
                            border={`2px dashed ${palette.primary.main}`}
                            p="1rem"
                            sx={{ "&:hover": { cursor: "pointer" } }}
                          >
                            <input {...getInputProps()} />
                            {!values.logo ? (
                              <p>Add logo Here</p>
                            ) : (
                              <FlexBetween>
                                <Typography>{values.logo.name}</Typography>
                                <EditOutlinedIcon />
                              </FlexBetween>
                            )}
                          </Box>
                        )}
                      </Dropzone>
                    </Box>

                    <Box
                      gridColumn="span 4"
                      border={`1px solid ${palette.neutral.medium}`}
                      borderRadius="5px"
                      p="1rem"
                    ></Box>
                  </>
                }
              </Box>

              {/* BUTTONS */}
              <Box width="80%" mx="auto">
                <Button
                  fullWidth
                  type="submit"
                  sx={{
                    m: "2rem 0",
                    p: "1rem",
                    backgroundColor: palette.secondary[300],
                    color: palette.background.alt,
                    ":hover": {
                      bgcolor: "primary.main", // theme.palette.primary.main
                      color: "white",
                    },
                  }}
                >
                  اضافة
                </Button>
              </Box>
            </form>
          )}
        </Formik>
      </Box>
    </div>
  );
};

export default AddCompany;
