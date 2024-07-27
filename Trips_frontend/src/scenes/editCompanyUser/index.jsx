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
import * as yup from "yup";
import React from "react";
import {
  useGetCompanyUserByIdQuery,
  useGetPermissionQuery,
  useUpdateCompanyUserMutation,
} from "state/api";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { toast } from "react-toastify";
import { useTranslation } from "react-i18next";
import { useNavigate, useParams } from "react-router-dom";
import { useEffect } from "react";

const EditCompanyUser = () => {
  const { palette } = useTheme();
  const { id } = useParams();
  const [t, i18n] = useTranslation();
  const { data: dataUserCompany } = useGetCompanyUserByIdQuery(id);
  const [selectedPermissions, setSelectedPermissions] = React.useState([]);
  const initialValuesRegister = {
    name: dataUserCompany?.data?.user?.name || "",
    username: dataUserCompany?.data?.user?.username || "",
    password: "",
    roles: dataUserCompany?.data?.user?.roles_ids || [],
  };
  const registerSchema = yup.object().shape({
    name: yup.string().required("required"),
    username: yup
      .string()
      .required("required")
      .matches(/^[a-zA-Z0-9@#$%^.&*]+$/, "يجب أن يحتوي على أحرف انكليزية  فقط"),
    password: yup
      .string()
      .matches(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/,
        " يجب ان تحتوي على أحرف كبيرة وأحرف صغيرة وأرقام ورموز مثل @ # ويجب أن لا تقل عن 8 محارف"
      ),
  });

  const [updateUser, { isSuccess, isError, error }] =
    useUpdateCompanyUserMutation();
  const { data, isLoading } = useGetPermissionQuery();

  const isNonMobile = useMediaQuery("(min-width:600px)");

  const navigate = useNavigate();

  const handleFormSubmit = async (values, onSubmitProps) => {
    console.log("values", values);
    values.id = id;
    await updateUser(values);
    toast.success("Success!");
    onSubmitProps.resetForm();
    navigate(-1);
  };

  return (
    <div>
      <Box m="6rem">
        <Formik
          enableReinitialize={true}
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
                      value={values.name}
                      name="name"
                      error={Boolean(touched.name) && Boolean(errors.name)}
                      helperText={touched.name && errors.name}
                      sx={{ gridColumn: "span 4" }}
                    />

                    <TextField
                      label=" اسم المستخدم  "
                      onBlur={handleBlur}
                      onChange={handleChange}
                      type="text"
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
                    <Typography
                      sx={{
                        gridColumn: "span 4",
                        color: "orange",
                        transform: "translate(0, -20px)",
                      }}
                      variant="h6"
                    >
                      تترك كلمة السر فارغة في حال عدم الرغبة في التغيير.
                    </Typography>
                    <Box gridColumn="4 span" textAlign="start">
                      <Typography variant="h3">الصلاحيات</Typography>
                    </Box>
                    {data?.data?.permissions?.map((role) => (
                      <FormControlLabel
                        key={role.id}
                        control={
                          <Checkbox
                            name="roles"
                            value={role.id}
                            checked={values.roles.includes(role.id)}
                            onChange={(e) => {
                              const value = role.id;
                              const isChecked = e.target.checked;
                              setFieldValue(
                                "roles",
                                isChecked
                                  ? [...values.roles, value]
                                  : values.roles.filter((d) => d !== value)
                              );
                            }}
                            color="primary"
                          />
                        }
                        label={role.name_ar}
                        sx={{ gridColumn: "span 2" }}
                      />
                    ))}

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
                  تعديل
                </Button>
              </Box>
            </form>
          )}
        </Formik>
      </Box>
    </div>
  );
};

export default EditCompanyUser;
