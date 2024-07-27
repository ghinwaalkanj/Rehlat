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
  useGetTripListInfoQuery,
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

const TripListInfo = () => {
  const { palette } = useTheme();
  const [t, i18n] = useTranslation();
  const { id } = useParams();
  const { data: dataTripList, isLoading: isTripListLoading } =
    useGetTripListInfoQuery(id);
  const { data: dataDrivers } = useGetDriversQuery();
  const { data: dataAssistants } = useGetAssistantsQuery();
  const { data: dataBuses } = useGetBusesQuery();
  useEffect(() => {
    console.log("eee", dataTripList);
  }, [isTripListLoading]);
  const initialValuesRegister = {
    source_city_id: dataTripList?.data?.source || "",
    destination_city_id: dataTripList?.data?.destination || "",
    ticket_price: dataTripList?.data?.ticket_price || "",
    driver_id: dataTripList?.data?.driver_id || "",
    percentage_price: dataTripList?.data?.percentage_price || "",
    driver_assistant_id: dataTripList?.data?.driver_assistant_id || "",
    bus_id: dataTripList?.data?.bus?.id || "",
    dateTime:
      dayjs(dataTripList?.data?.start_date) || dayjs("2022-04-17T15:30"),
    daysOfWeek: dataTripList?.data?.days || [],
  };
  const registerSchema = yup.object().shape({
    source_city_id: yup.string().required("required"),
    destination_city_id: yup.string().required("required"),
    ticket_price: yup.string().required("required"),
    bus_id: yup.number().required("required"),
    daysOfWeek: yup.array(),
    // .min(1, "Select at least one day")
    // .required("required"),
  });
  const [updateTripList, { isSuccess, isLoading: isUpdateLoading }] =
    useUpdateTripListMutation();
  const days = [
    { label: "Sunday", value: 1 },
    { label: "Monday", value: 2 },
    { label: "Tuesday", value: 3 },
    { label: "Wednesday", value: 4 },
    { label: "Thursday", value: 5 },
    { label: "Friday", value: 6 },
    { label: "Saturday", value: 7 },
  ];
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
    await updateTripList(values);
    // onSubmitProps.resetForm();
    // history.goBack();
    showSuccessMessage();
    navigate(-1);
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
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogTitle id="alert-dialog-title">
          {"Use Google's location service?"}
        </DialogTitle>
        <DialogContent>
          <DialogContentText id="alert-dialog-description">
            Let Google help apps determine location. This means sending
            anonymous location data to Google, even when no apps are running.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Disagree</Button>
          <Button onClick={handleClose} autoFocus>
            Agree
          </Button>
        </DialogActions>
      </Dialog>
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
                  <FormControl sx={{ gridColumn: "span 2" }}>
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
                  <FormControl sx={{ gridColumn: "span 2" }}>
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
                          <MobileTimePicker
                            sx={{
                              flexBasis: "100%",
                            }}
                            value={values.dateTime}
                            onChange={(v) => setFieldValue("dateTime", v)}
                          />
                        </LocalizationProvider>
                      </Box>
                      <Box width="100%">
                        <FormControl fullWidth>
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
                        initialValuesRegister.percentage_price !==
                          newValue
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

                  <Box gridColumn="span 2">
                    {days.map((day) => (
                      <FormControlLabel
                        key={day.value}
                        control={
                          <Checkbox
                            name="daysOfWeek"
                            value={day.value}
                            checked={values.daysOfWeek.includes(day.value)}
                            onChange={(e) => {
                              const value = day.value;
                              const isChecked = e.target.checked;
                              setFieldValue(
                                "daysOfWeek",
                                isChecked
                                  ? [...values.daysOfWeek, value]
                                  : values.daysOfWeek.filter((d) => d !== value)
                              );
                            }}
                            color="primary"
                          />
                        }
                        label={day.label}
                        sx={{ gridColumn: "span 2" }}
                      />
                    ))}
                    {Boolean(touched.daysOfWeek) &&
                      Boolean(errors.daysOfWeek) && (
                        <Box color="red">{errors.daysOfWeek}</Box>
                      )}
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
                <Typography variant="h5">
                  {" "}
                  <span
                    style={{
                      color: "red",
                    }}
                  >
                    تنبيه :
                  </span>{" "}
                  الرحلات التي تم فيها حجز واحد على الاقل لن تتغير{" "}
                </Typography>
              </Box>
            </form>
          )}
        </Formik>
      </Box>
    </div>
  );
};

export default TripListInfo;
