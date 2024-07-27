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
  useGetAssistantsQuery,
  useGetBusesQuery,
  useGetCitiesQuery,
  useGetDriversQuery,
  useGetParamsQuery,
  useGetTripListInfoQuery,
  useUpdateParamsMutation,
  useUpdateTripListMutation,
} from "state/api";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";

import { toast } from "react-toastify";

import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";

import dayjs from "dayjs";
import { MobileTimePicker } from "@mui/x-date-pickers";
import { useTranslation } from "react-i18next";
import { useNavigate, useParams } from "react-router-dom";
import { useEffect } from "react";

const EditParameters = () => {
  const { palette } = useTheme();
  const [t, i18n] = useTranslation();
  const { id } = useParams();
  const { data: dataTripList, isLoading: isTripListLoading } =
    useGetParamsQuery();

  useEffect(() => {
    console.log("eee", dataTripList);
  }, [isTripListLoading]);
  const initialValuesRegister = {
    timer: dataTripList?.data?.params?.timer || "",
    extra_time: dataTripList?.data?.params?.extra_time || "",
    paid_reservation_confirmation:
      dataTripList?.data?.params?.paid_reservation_confirmation || "",
    paid_reservation_confirmation_en:
      dataTripList?.data?.params?.paid_reservation_confirmation_en || "",
    paid_reservation_cancel:
      dataTripList?.data?.params?.paid_reservation_cancel || "",
    paid_reservation_cancel_en:
      dataTripList?.data?.params?.paid_reservation_cancel_en || "",
    temporary_reservation_cancel:
      dataTripList?.data?.params?.temporary_reservation_cancel || "",
    temporary_reservation_cancel_en:
      dataTripList?.data?.params?.temporary_reservation_cancel_en || "",
   
    minute_try_otp: dataTripList?.data?.params?.minute_try_otp || "",
    max_requests: dataTripList?.data?.params?.max_requests || "",
    max_reservation: dataTripList?.data?.params?.max_reservation || "",
  };

  const registerSchema = yup.object().shape({
    timer: yup.string().required("required"),
    extra_time: yup.string().required("required"),
    paid_reservation_confirmation: yup.string().required("required"), //notification
    temporary_reservation_cancel: yup.string().required("required"), //sms
    paid_reservation_cancel: yup.string().required("required"), //sms
    minute_try_otp: yup.string().required("required"),
    max_requests: yup.string().required("required"),
    max_reservation: yup.string().required("required"),
  });
  const [updateParams, { isSuccess, isLoading: isUpdateLoading }] =
    useUpdateParamsMutation();

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
    await updateParams(values);
    // onSubmitProps.resetForm();
    showSuccessMessage();
    navigate("/admin/");
  };

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
                  <TextField
                    label="وقت الانتظار"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("timer", newValue);
                      console.log("old", initialValuesRegister.timer);
                      console.log("new", newValue);
                      setTicketPriceChanged(
                        initialValuesRegister.timer.toString() !== newValue
                      );
                    }}
                    value={values.timer}
                    name="timer"
                    error={Boolean(touched.timer) && Boolean(errors.timer)}
                    helperText={touched.timer && errors.timer}
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="عدد وقت التمديد "
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = parseInt(e.target.value);
                      setFieldValue("extra_time", newValue);
                      console.log("old", initialValuesRegister.extra_time);
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.extra_time !== newValue
                      );
                    }}
                    type="number"
                    value={values.extra_time}
                    name="extra_time"
                    error={
                      Boolean(touched.extra_time) && Boolean(errors.extra_time)
                    }
                    helperText={touched.extra_time && errors.extra_time}
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label=" اشعار تأكيد الحجز المدفوع باللغة العربية"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("paid_reservation_confirmation", newValue);
                      console.log(
                        "old",
                        initialValuesRegister.paid_reservation_confirmation
                      );
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.paid_reservation_confirmation !==
                          newValue
                      );
                    }}
                    type="text"
                    value={values.paid_reservation_confirmation}
                    name="paid_reservation_confirmation"
                    error={
                      Boolean(touched.paid_reservation_confirmation) &&
                      Boolean(errors.paid_reservation_confirmation)
                    }
                    helperText={
                      touched.paid_reservation_confirmation &&
                      errors.paid_reservation_confirmation
                    }
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label=" اشعار تأكيد الحجز المدفوع باللغة الانكليزية"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("paid_reservation_confirmation_en", newValue);
                      console.log(
                        "old",
                        initialValuesRegister.paid_reservation_confirmation_en
                      );
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.paid_reservation_confirmation_en !==
                          newValue
                      );
                    }}
                    type="text"
                    value={values.paid_reservation_confirmation_en}
                    name="paid_reservation_confirmation_en"
                    error={
                      Boolean(touched.paid_reservation_confirmation_en) &&
                      Boolean(errors.paid_reservation_confirmation_en)
                    }
                    helperText={
                      touched.paid_reservation_confirmation &&
                      errors.paid_reservation_confirmation
                    }
                    sx={{ gridColumn: "span 2" }}
                  />
                 
                  <TextField
                    label="رسالة الغاء الحجز المدفوع باللغة العربية"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("paid_reservation_cancel", newValue);
                      console.log(
                        "old",
                        initialValuesRegister.paid_reservation_cancel
                      );
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.paid_reservation_cancel !==
                          newValue
                      );
                    }}
                    type="text"
                    value={values.paid_reservation_cancel}
                    name="paid_reservation_cancel"
                    error={
                      Boolean(touched.paid_reservation_cancel) &&
                      Boolean(errors.paid_reservation_cancel)
                    }
                    helperText={
                      touched.paid_reservation_cancel &&
                      errors.paid_reservation_cancel
                    }
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="رسالة الغاء الحجز المدفوع باللغة الانكليزية"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("paid_reservation_cancel_en", newValue);
                      console.log(
                        "old",
                        initialValuesRegister.paid_reservation_cancel_en
                      );
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.paid_reservation_cancel_en !==
                          newValue
                      );
                    }}
                    type="text"
                    value={values.paid_reservation_cancel_en}
                    name="paid_reservation_cancel_en"
                    error={
                      Boolean(touched.paid_reservation_cancel_en) &&
                      Boolean(errors.paid_reservation_cancel_en)
                    }
                    helperText={
                      touched.paid_reservation_cancel_en &&
                      errors.paid_reservation_cancel_en
                    }
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="رسالة الغاء الحجز المؤقت باللغة العربية"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("temporary_reservation_cancel", newValue);
                      console.log(
                        "old",
                        initialValuesRegister.temporary_reservation_cancel
                      );
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.temporary_reservation_cancel !==
                          newValue
                      );
                    }}
                    type="text"
                    value={values.temporary_reservation_cancel}
                    name="temporary_reservation_cancel"
                    error={
                      Boolean(touched.temporary_reservation_cancel) &&
                      Boolean(errors.temporary_reservation_cancel)
                    }
                    helperText={
                      touched.temporary_reservation_cancel &&
                      errors.temporary_reservation_cancel
                    }
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="رسالة الغاء الحجز المؤقت باللغة الانكليزية"
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("temporary_reservation_cancel_en", newValue);
                      console.log(
                        "old",
                        initialValuesRegister.temporary_reservation_cancel_en
                      );
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.temporary_reservation_cancel_en !==
                          newValue
                      );
                    }}
                    type="text"
                    value={values.temporary_reservation_cancel_en}
                    name="temporary_reservation_cancel_en"
                    error={
                      Boolean(touched.temporary_reservation_cancel_en) &&
                      Boolean(errors.temporary_reservation_cancel_en)
                    }
                    helperText={
                      touched.temporary_reservation_cancel_en &&
                      errors.temporary_reservation_cancel_en
                    }
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="عدد دقائق الحظر على تجريب وطلب الرسائل   "
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = parseInt(e.target.value);
                      setFieldValue("minute_try_otp", newValue);
                      console.log("old", initialValuesRegister.minute_try_otp);
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.minute_try_otp !== newValue
                      );
                    }}
                    type="number"
                    value={values.minute_try_otp}
                    name="minute_try_otp"
                    error={
                      Boolean(touched.minute_try_otp) &&
                      Boolean(errors.minute_try_otp)
                    }
                    helperText={touched.minute_try_otp && errors.minute_try_otp}
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="عدد مرات تجريب وطلب الرسائل   "
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = parseInt(e.target.value);
                      setFieldValue("max_requests", newValue);
                      console.log("old", initialValuesRegister.max_requests);
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.max_requests !== newValue
                      );
                    }}
                    type="number"
                    value={values.max_requests}
                    name="max_requests"
                    error={
                      Boolean(touched.max_requests) &&
                      Boolean(errors.max_requests)
                    }
                    helperText={touched.max_requests && errors.max_requests}
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="عدد المقاعد المسموح بها  "
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = parseInt(e.target.value);
                      setFieldValue("max_reservation", newValue);
                      console.log("old", initialValuesRegister.max_reservation);
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.max_reservation !== newValue
                      );
                    }}
                    type="number"
                    value={values.max_reservation}
                    name="max_reservation"
                    error={
                      Boolean(touched.max_reservation) &&
                      Boolean(errors.max_reservation)
                    }
                    helperText={touched.max_reservation && errors.max_reservation}
                    sx={{ gridColumn: "span 2" }}
                  />

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
                  disabled={
                    (!dirty &&
                      !ticketPriceChanged &&
                      !percentagePriceChanged) ||
                    isUpdateLoading
                  }
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

export default EditParameters;
