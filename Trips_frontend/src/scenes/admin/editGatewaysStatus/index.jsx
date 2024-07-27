import {
  Box,
  Button,
  Checkbox,
  FormControl,
  FormControlLabel,
  InputLabel,
  MenuItem,
  Select,
  Switch,
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
  useGetGatewaysStatusQuery,
  useGetParamsQuery,
  useGetTripListInfoQuery,
  useUpdateGatewaysStatusMutation,
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

const EditGatewaysStatus = () => {
  const { palette } = useTheme();
  const [t, i18n] = useTranslation();
  const { id } = useParams();
  const { data: dataTripList, isLoading: isTripListLoading } =
    useGetGatewaysStatusQuery();

  useEffect(() => {
    console.log("eee", dataTripList);
  }, [isTripListLoading]);
  const initialValuesRegister = {
    fatora: dataTripList?.data?.status?.fatora || "",
    mtn_cash: dataTripList?.data?.status?.mtn_cash || "",
    syriatel_cash: dataTripList?.data?.status?.syriatel_cash || "",
  };
  const registerSchema = yup.object().shape({
    fatora: yup.string().required("required"),
    mtn_cash: yup.string().required("required"),
    syriatel_cash: yup.string().required("required"),
  });
  const [updateGatewaysStatus, { isSuccess, isLoading: isUpdateLoading }] =
    useUpdateGatewaysStatusMutation();

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

    await updateGatewaysStatus(values);
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
                  <FormControlLabel
                    control={
                      <Switch
                        checked={values.fatora}
                        onChange={(e) => {
                          const newValue = e.target.checked;
                          setFieldValue("fatora", newValue);
                        }}
                        name="fatora"
                        sx={{
                          "& .MuiSwitch-switchBase.Mui-checked": {
                            color: "#00c851",
                          },
                        }}
                      />
                    }
                    label="fatora"
                    sx={{ gridColumn: "span 2" }}
                  />

                  <FormControlLabel
                    control={
                      <Switch
                        checked={values.mtn_cash}
                        onChange={(e) => {
                          const newValue = e.target.checked;
                          setFieldValue("mtn_cash", newValue);
                        }}
                        name="mtn_cash"
                        sx={{
                          "& .MuiSwitch-switchBase.Mui-checked": {
                            color: "#00c851",
                          },
                        }}
                      />
                    }
                    label="mtn cash"
                    sx={{ gridColumn: "span 2" }}
                  />
                  <FormControlLabel
                    control={
                      <Switch
                        checked={values.syriatel_cash}
                        onChange={(e) => {
                          const newValue = e.target.checked;
                          setFieldValue("syriatel_cash", newValue);
                        }}
                        name="syriatel cash"
                        sx={{
                          "& .MuiSwitch-switchBase.Mui-checked": {
                            color: "#00c851",
                          },
                        }}
                      />
                    }
                    label="syriatel cash"
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

export default EditGatewaysStatus;
