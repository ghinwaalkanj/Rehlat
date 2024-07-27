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
  useGetTripInfoQuery,
  useGetTripListInfoQuery,
  useUpdateTripListMutation,
  useUpdateTripMutation,
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
import {
  DatePicker,
  DateTimePicker,
  MobileTimePicker,
} from "@mui/x-date-pickers";
import { useTranslation } from "react-i18next";
import { useNavigate, useParams } from "react-router-dom";
import { useEffect } from "react";

const EditSingleTrip = () => {
  const { palette } = useTheme();
  const [t, i18n] = useTranslation();
  const { id } = useParams();
  const { data: dataTripList, isLoading: isTripListLoading } =
    useGetTripInfoQuery(id);
  // const dataTripList = props;
  const { data: dataDrivers } = useGetDriversQuery();
  const { data: dataAssistants } = useGetAssistantsQuery();
  const { data: dataBuses } = useGetBusesQuery();

  const initialValuesRegister = {
    source_city_id: dataTripList?.data?.trip?.source_city.id || "",
    destination_city_id: dataTripList?.data?.trip?.destination_city.id || "",
    ticket_price: dataTripList?.data?.trip?.ticket_price || "",
    driver_id: dataTripList?.data?.trip?.driver_id || "",
    percentage_price: dataTripList?.data?.trip?.percentage_price || "",
    driver_assistant_id: dataTripList?.data?.trip?.driver_assistant_id || "",
    bus_id: dataTripList?.data?.trip?.bus?.id || "",
    dateTime:
      dayjs(dataTripList?.data?.trip?.start_date) || dayjs("2022-04-17T15:30"),
  };
  const registerSchema = yup.object().shape({
    source_city_id: yup.string().required("required"),
    destination_city_id: yup.string().required("required"),
    ticket_price: yup.string().required("required"),
    bus_id: yup.number().required("required"),
    // .min(1, "Select at least one day")
    // .required("required"),
  });
  const [updateTrip, { isSuccess, isLoading: isUpdateLoading }] =
    useUpdateTripMutation();

  const isNonMobile = useMediaQuery("(min-width:600px)");
  const { data, isLoading } = useGetCitiesQuery();
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
    values.start_date = values.dateTime;
    delete values.dateTime;
    await updateTrip(values);
    // onSubmitProps.resetForm();
    // history.goBack();
    showSuccessMessage();
    navigate(`/trips/${id}`);
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
                  <FormControl  sx={{ gridColumn: "span 2" }}>
                    <InputLabel id="location-label">{t("source")}</InputLabel>
                    <Select
                      labelId="location-label"
                      id="location"
                      name="source_city_id"
                      value={values.source_city_id}
                      onChange={(e) =>
                        setFieldValue("source_city_id", e.target.value)
                      }
                      onBlur={handleBlur}
                      error={
                        Boolean(touched.source_city_id) &&
                        Boolean(errors.source_city_id)
                      }
                    >
                      {data?.data?.cities.map((city) => (
                        <MenuItem key={city.id} value={city.id}>
                          {city.name_ar}
                        </MenuItem>
                      ))}
                    </Select>
                    {touched.source_city_id && errors.source_city_id && (
                      <div className="error-message">
                        {errors.source_city_id}
                      </div>
                    )}
                  </FormControl>
                  <FormControl  sx={{ gridColumn: "span 2" }}>
                    <InputLabel id="location-label">
                      {t("destination")}
                    </InputLabel>
                    <Select
                      labelId="location-label"
                      id="location"
                      name="destination_city_id"
                      value={values.destination_city_id}
                      onChange={(e) =>
                        setFieldValue("destination_city_id", e.target.value)
                      }
                      onBlur={handleBlur}
                      error={
                        Boolean(touched.destination_city_id) &&
                        Boolean(errors.destination_city_id)
                      }
                    >
                      {data?.data?.cities.map((city) => (
                        <MenuItem key={city.id} value={city.id}>
                          {city.name_ar}
                        </MenuItem>
                      ))}
                    </Select>
                    {touched.destination_city_id &&
                      errors.destination_city_id && (
                        <div className="error-message">
                          {errors.destination_city_id}
                        </div>
                      )}
                  </FormControl>
                  <Box sx={{ gridColumn: "span 4" }}>
                    <Box
                      display="flex"
                      alignItems="center"
                      width="100%"
                      gap="2rem"
                    >
                      <Box width="100%" display="flex" alignItems="center">
                        <LocalizationProvider dateAdapter={AdapterDayjs}>
                          <DateTimePicker
                            
                            sx={{
                              flexBasis: "100%",
                            }}
                            value={values.dateTime}
                            onChange={(v) => setFieldValue("dateTime", v)}
                          />
                        </LocalizationProvider>
                      </Box>
                      <Box width="100%">
                        <FormControl  fullWidth>
                          <InputLabel id="location-label">
                            {t("bus_type")}
                          </InputLabel>
                          <Select
                            labelId="location-label"
                            id="location"
                            name="bus_id"
                            value={values.bus_id}
                            onChange={(e) =>
                              setFieldValue("bus_id", e.target.value)
                            }
                            onBlur={handleBlur}
                            error={
                              Boolean(touched.bus_id) && Boolean(errors.bus_id)
                            }
                          >
                            {dataBuses?.data?.buses.map((bus) => (
                              <MenuItem key={bus.id} value={bus.id}>
                                {bus.details}
                              </MenuItem>
                            ))}
                          </Select>
                          {touched.bus_type && errors.bus_type && (
                            <div className="error-message">
                              {errors.bus_type}
                            </div>
                          )}
                        </FormControl>
                      </Box>
                    </Box>
                  </Box>
                  {/* start driver */}
                  <Box sx={{ gridColumn: "span 4" }}>
                    <Box
                      display="flex"
                      alignItems="center"
                      width="100%"
                      gap="2rem"
                    >
                      <Box width="100%">
                        <FormControl fullWidth>
                          <InputLabel id="location-label">
                            {t("السائق")}
                          </InputLabel>
                          <Select
                            labelId="location-label"
                            id="location"
                            name="driver_id"
                            value={values.driver_id}
                            onChange={(v) =>
                              setFieldValue("driver_id", v.target.value)
                            }
                            onBlur={handleBlur}
                            error={
                              Boolean(touched.driver_id) &&
                              Boolean(errors.driver_id)
                            }
                          >
                            {/* <MenuItem value="">الانطلاق</MenuItem> */}
                            {dataDrivers?.data?.drivers.map((driver) => (
                              <MenuItem key={driver.id} value={driver.id}>
                                {driver.name}
                              </MenuItem>
                            ))}
                            {/* <MenuItem value="1">VIP</MenuItem>
                              <MenuItem value="2">Normal</MenuItem>
                              <MenuItem value="3">Small</MenuItem> */}

                            {/* Add more MenuItem components for your options */}
                          </Select>
                          {touched.driver_id && errors.driver_id && (
                            <div className="error-message">
                              {errors.driver_id}
                            </div>
                          )}
                        </FormControl>
                      </Box>
                      {/* <Typography variant="h5">تاريخ الانطلاق</Typography> */}
                      <Box width="100%">
                        <FormControl fullWidth>
                          <InputLabel id="location-label">
                            {t("مساعد السائق")}
                          </InputLabel>
                          <Select
                            labelId="location-label"
                            id="location"
                            name="driver_assistant_id"
                            value={values.driver_assistant_id}
                            onChange={(v) =>
                              setFieldValue(
                                "driver_assistant_id",
                                v.target.value
                              )
                            }
                            onBlur={handleBlur}
                            error={
                              Boolean(touched.driver_assistant_id) &&
                              Boolean(errors.driver_assistant_id)
                            }
                          >
                            {/* <MenuItem value="">الانطلاق</MenuItem> */}
                            {dataAssistants?.data?.drivers_assistant.map(
                              (assistant) => (
                                <MenuItem
                                  key={assistant.id}
                                  value={assistant.id}
                                >
                                  {assistant.name}
                                </MenuItem>
                              )
                            )}
                            {/* <MenuItem value="1">VIP</MenuItem>
                              <MenuItem value="2">Normal</MenuItem>
                              <MenuItem value="3">Small</MenuItem> */}

                            {/* Add more MenuItem components for your options */}
                          </Select>
                          {touched.driver_assistant_id &&
                            errors.driver_assistant_id && (
                              <div className="error-message">
                                {errors.driver_assistant_id}
                              </div>
                            )}
                        </FormControl>
                      </Box>
                    </Box>
                  </Box>
                  {/* end driver */}
                  <TextField
                    
                    label={t("ticket_price")}
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = e.target.value;
                      setFieldValue("ticket_price", parseInt(newValue));
                      console.log("old", initialValuesRegister.ticket_price);
                      console.log("new", newValue);
                      console.log(
                        "compare",
                        initialValuesRegister.ticket_price.toString() !==
                          newValue
                      );
                      setTicketPriceChanged(
                        initialValuesRegister.ticket_price.toString() !==
                          newValue
                      );
                    }}
                    value={values.ticket_price}
                    name="ticket_price"
                    error={
                      Boolean(touched.ticket_price) &&
                      Boolean(errors.ticket_price)
                    }
                    helperText={touched.ticket_price && errors.ticket_price}
                    sx={{ gridColumn: "span 2" }}
                  />
                  <TextField
                    label="النسبة المضافة"
                    
                    onBlur={handleBlur}
                    onChange={(e) => {
                      const newValue = parseInt(e.target.value);
                      setFieldValue("percentage_price", newValue);
                      console.log(
                        "old",
                        initialValuesRegister.percentage_price
                      );
                      console.log("new", newValue);
                      setPercentagePriceChanged(
                        initialValuesRegister.percentage_price !== newValue
                      );
                    }}
                    type="number"
                    value={values.percentage_price}
                    name="percentage_price"
                    error={
                      Boolean(touched.percentage_price) &&
                      Boolean(errors.percentage_price)
                    }
                    helperText={
                      touched.percentage_price && errors.percentage_price
                    }
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
                  {t("edit_trip")}
                </Button>
              </Box>
            </form>
          )}
        </Formik>
      </Box>
    </div>
  );
};

export default EditSingleTrip;
