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
import EditOutlinedIcon from "@mui/icons-material/EditOutlined";
import { Formik } from "formik";
import Dropzone from "react-dropzone";
import * as yup from "yup";
import React from "react";
import { useGetCompanyQuery, useUpdateCompanyMutation } from "state/api";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { toast } from "react-toastify";
import { useTranslation } from "react-i18next";
import { useNavigate, useParams } from "react-router-dom";
import { useEffect } from "react";
import FlexBetween from "components/FlexBetween";

const EditCompany = () => {
  const { palette } = useTheme();
  const [t, i18n] = useTranslation();
  const { id } = useParams();
  const { data: dataTripList, isLoading: isTripListLoading } =
    useGetCompanyQuery(id);
  // const dataTripList = props;

  const initialValuesRegister = {
    name_ar: dataTripList?.data?.company?.name_ar || "",
    name_en: dataTripList?.data?.company?.name_en || "",
    username: dataTripList?.data?.company?.username || "",
    logo: "",
    password: "",
  };
  const registerSchema = yup.object().shape({
    name_ar: yup.string().required("required"),
    name_en: yup.string().required("required"),
    password: yup
      .string()
      .matches(
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/,
        " يجب ان تحتوي على أحرف كبيرة وأحرف صغيرة وأرقام ورموز مثل @ # ويجب أن لا تقل عن 8 محارف"
      ),
  });
  const [updateCompany, { isSuccess, isLoading: isUpdateLoading }] =
    useUpdateCompanyMutation();
  const isNonMobile = useMediaQuery("(min-width:600px)");
  const navigate = useNavigate();
  const showSuccessMessage = () => {
    toast.success("Success!", {
      position: "top-right", // You can adjust the position
      autoClose: 3000, // Close the toast after 3 seconds (adjust as needed)
      hideProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
      draggable: true,
    });
  };
  const handleFormSubmit = async (values, onSubmitProps) => {
    console.log("valuese", values);
    values.id = id;

    await updateCompany(values);
    // onSubmitProps.resetForm();
    // history.goBack();
    showSuccessMessage();
    navigate(`/admin/get_companies`);
  };

  const [open, setOpen] = React.useState(false);
  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const [buttonDisabled, setButtonDisabled] = React.useState(true);
  const [ticketPriceChanged, setTicketPriceChanged] = React.useState(false);
  const [percentagePriceChanged, setPercentagePriceChanged] =
    React.useState(false);
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
            handleSubmit,
            setFieldValue,
            resetForm,
            dirty, // Check if any field has been edited
          }) => (
            <form onSubmit={handleSubmit}>
              {/* {console.log("values", values)} */}
              <Box
                display="grid"
                gap="30px"
                gridTemplateColumns="repeat(4, minmax(0, 1fr))"
                sx={{
                  "& > div": { gridColumn: isNonMobile ? undefined : "span 4" },
                }}
              >
                <>
                  {/* start driver */}

                  {/* end driver */}
                  <TextField
                    label="الاسم بالعربي"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("name_ar", newValue);
                    }}
                    value={values.name_ar}
                    name="name_ar"
                    error={Boolean(touched.name_ar) && Boolean(errors.name_ar)}
                    helperText={touched.name_ar && errors.name_ar}
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="الاسم بالانجليزي"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("name_en", newValue);
                    }}
                    value={values.name_en}
                    name="name_en"
                    error={Boolean(touched.name_en) && Boolean(errors.name_en)}
                    helperText={touched.name_en && errors.name_en}
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="الباسوورد "
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("password", newValue);
                    }}
                    hintText="اتركه فارغا لعدم التغيير"
                    value={values.password}
                    name="password"
                    error={
                      Boolean(touched.password) && Boolean(errors.password)
                    }
                    helperText={touched.password && errors.password}
                    sx={{ gridColumn: "span 4" }}
                  />
                  <TextField
                    label=" اسم المستخدم  "
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("username", newValue);
                    }}
                    value={values.username}
                    name="username"
                    error={
                      Boolean(touched.username) && Boolean(errors.username)
                    }
                    helperText={touched.username && errors.username}
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
              </Box>

              {/* BUTTONS */}
              <Box>
                <Button
                  fullWidth
                  disabled={!dirty || isUpdateLoading}
                  type="submit"
                  sx={{
                    m: "2rem 0",
                    p: "1rem",
                    backgroundColor: palette.secondary[300],
                    color: palette.background.alt,
                    ":hover": {
                      bgcolor: "primary.main",
                      color: "white",
                    },
                    "&:disabled": {
                      color: "grey",
                      bgcolor: palette.secondary[900],
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

export default EditCompany;
