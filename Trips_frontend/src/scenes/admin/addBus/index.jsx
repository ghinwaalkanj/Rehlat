/* eslint-disable react-hooks/rules-of-hooks */
import React, { useState } from "react";
import { Formik } from "formik";
import * as yup from "yup";
import {
  Box,
  Button,
  Checkbox,
  FormControl,
  FormControlLabel,
  InputLabel,
  Modal,
  MenuItem,
  Select,
  TextField,
  Typography,
  useMediaQuery,
  useTheme,
  useThemeProps,
} from "@mui/material";
import { useTranslation } from "react-i18next";
import {
  useGetBusesQuery,
  useAddBusMutation,
  useDeleteBusMutation,
} from "state/api";
import { DataGrid } from "@mui/x-data-grid";
const AddBus = () => {
  const [t, i18n] = useTranslation();
  // const defaultOptions = {
  //   loop: true,
  //   autoplay: true,
  //   animationData: animationData,
  //   rendererSettings: {
  //     preserveAspectRatio: "xMidYMid slice",
  //   },
  // };
  // const defaultOptionsSearch = {
  //   loop: true,
  //   autoplay: true,
  //   animationData: animationSearch,
  //   rendererSettings: {
  //     preserveAspectRatio: "xMidYMid slice",
  //   },
  // };

  const { palette } = useTheme();
  const theme = useTheme();
  const [isSearchLoading, setIsSearchLoading] = useState(false);
  const initialValuesRegister = {
    name: "",
    number_seat: "",
  };
  // const queryClient = useQueryClient();

  const registerSchema = yup.object().shape({
    // source_city_id: yup.string().required("required"),
    // destination_city_id: yup.string().required("required"),
    // tripNumber: yup.string().required("required"),
    // bus_type: yup.string().required("required"),
    // daysOfWeek: yup
    //   .array()
    //   .min(1, "Select at least one day")
    //   .required("required"),
  });

  const isNonMobile = useMediaQuery("(min-width:600px)");
  const { data, isLoading } = useGetBusesQuery();
  const [addBus, { isLoading: isAddBusLoading }] = useAddBusMutation();
  const [deleteBus, { isLoading: isDeleteBusLoading }] = useDeleteBusMutation();
  const [page, setPage] = useState(0);
  const handleFormSubmit = async (values, onSubmitProps) => {
    await addBus(values);
    // console.log("data", data.results);;
    onSubmitProps.resetForm();
  };
  const [openReservation, setOpenReservation] = React.useState(false);
  const handleConfirmClose = () => setOpenReservation(false);
  const [idToDelete, setIdToDelete] = useState(null);
  const styleModal = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 400,
    bgcolor: "background.paper",
    border: "2px solid #000",
    // boxShadow: 24,
    p: 4,
  };
  const onConfirmClicked = async () => {
    await deleteBus(idToDelete);
    setOpenReservation(false);
    // await reserveSeats({ ids: selectedIds, full_name: fullName, phone: phone });
    // if (response.isSuccess) {
    //   setFullName('');
    //   handleConfirmClose();
    //   setSelectedIds([]);
    // }
  };
  const columns = [
    {
      field: "name",
      headerName: "الاسم",
      flex: 1,
    },
    {
      field: "number_seat",
      headerName: "عدد المقاعد",
      flex: 1,
    },

    {
      field: "actions",
      headerName: "Actions",
      width: 180,
      renderCell: (params) => (
        <div>
          {/* <Box
          display="inline-block"
          sx={{
            "& .MuiButton-outlined": {
              borderColor: theme.palette.secondary[300] + "!important",
              color: theme.palette.secondary[300],
            },
          }}
        >
          <Button
            sx={{ marginLeft: "12px" }}
            onClick={() => navigate(`/trips/${params.id}`)}
            variant="outlined"
          >
            {t("show")}
          </Button>
        </Box> */}

          {!params.row.deleted_at?(
            <Button
            variant="outlined"
            onClick={() => {
              setIdToDelete(params.id);
              setOpenReservation(true);
            }}
            color="error"
          >
            {t("delete")}
          </Button>
          ):(<div> لقد تم الغاءه</div>) }
        </div>
      ),
    },
  ];
  return (
    <div>
      <Modal
        open={openReservation}
        onClose={handleConfirmClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <div>
          <Box sx={styleModal}>
            <Typography
              sx={{ mb: "2rem" }}
              id="modal-modal-title"
              variant="h6"
              component="h2"
            >
              Are you sure delete this bus?
            </Typography>

            <Button color="success" onClick={handleConfirmClose}>
              Close
            </Button>
            <Button color="error" onClick={onConfirmClicked}>
              Delete
            </Button>
          </Box>
        </div>
      </Modal>

      <Box m="10% 15% 5%">
        <Typography sx={{ mb: "2rem" }} variant="h3">
          {t("add_bus")}
        </Typography>
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
            dirty,
          }) => (
            <form onSubmit={handleSubmit}>
              {console.log("values", values)}
              <Box
                display="grid"
                gap="30px"
                gridTemplateColumns="repeat(4, minmax(0, 1fr))"
                sx={{
                  "& > div": { gridColumn: isNonMobile ? undefined : "span 4" },
                }}
              >
                {
                  <>
                    {/* <DemoItem label="Mobile variant"> */}
                    <Box sx={{ gridColumn: "span 4" }}>
                      <Box
                        display="flex"
                        alignItems="center"
                        width="100%"
                        gap="2rem"
                      >
                        <Box width="100%">
                          <TextField
                            fullWidth
                            label="ادخل اسم الباص"
                            onBlur={handleBlur}
                            onChange={handleChange}
                            value={values.name}
                            name="name"
                            error={
                              Boolean(touched.name) && Boolean(errors.name)
                            }
                            helperText={touched.name && errors.name}
                            sx={{ gridColumn: "span 4" }}
                          />
                        </Box>
                      </Box>
                    </Box>
                    <Box sx={{ gridColumn: "span 4" }}>
                      <Box
                        display="flex"
                        alignItems="center"
                        width="100%"
                        gap="2rem"
                      >
                        <Box width="100%">
                          <TextField
                            fullWidth
                            label="عدد الركاب"
                            type="number"
                            onBlur={handleBlur}
                            onChange={handleChange}
                            value={values.number_seat}
                            name="number_seat"
                            error={
                              Boolean(touched.number_seat) &&
                              Boolean(errors.number_seat)
                            }
                            helperText={
                              touched.number_seat && errors.number_seat
                            }
                            sx={{ gridColumn: "span 4" }}
                          />
                        </Box>
                      </Box>
                    </Box>
                  </>
                }
              </Box>

              {/* BUTTONS */}
              <Box>
                <Button
                  fullWidth
                  type="submit"
                  // disabled={!dirty}
                  sx={{
                    m: "2rem 0 0 0",
                    p: "1rem",
                    backgroundColor: palette.secondary[300],
                    color: palette.background.alt,
                    ":hover": {
                      bgcolor: "primary.main", // theme.palette.primary.main
                      color: "white",
                    },
                  }}
                >
                  {t("اضافة")}
                </Button>
              </Box>
            </form>
          )}
        </Formik>
        {/* {isSearchLoading && (
        // <Lottie
        //   options={defaultOptionsSearch}
        //   height={400}
        //   width={400}
        //   // isStopped={this.state.isStopped}
        //   // isPaused={this.state.isPaused}
        // />
      )} */}
      </Box>

      {/* {searchResults && searchResults.length > 0 && (
      <ResultSearch searchData={searchResults} />
    )}
    {searchResults && !isSearchLoading && searchResults.length === 0 && (
      <Box>
        <Typography variant="h3" sx={{ textAlign: "center" }}>
          لاتوجد نتائج للبحث
        </Typography>
        <Lottie
          options={defaultOptions}
          height={400}
          width={400}
          // isStopped={this.state.isStopped}
          // isPaused={this.state.isPaused}
        /> */}
      {/* </Box>
    )} */}

      <Box m="0.5rem 0.5rem">
        {/* <Header title="الرحلات" subtitle="قائمة الرحلات القادمة"  /> */}
        <Typography
          sx={{ textAlign: "center", marginBottom: "1rem" }}
          variant="h4"
        >
          المضافة مسبقاََ
        </Typography>
        <Box
          height="80vh"
          sx={{
            "& .MuiDataGrid-root": {
              border: "none",
            },
            "& .MuiDataGrid-cell": {
              borderBottom: "none",
              fontSize:"16px"
            },
            "& .MuiDataGrid-columnHeaders": {
              backgroundColor: theme.palette.background.alt,
              color: theme.palette.secondary[50],
              borderBottom: "none",
              fontSize:"16px"
            },
            "& .MuiDataGrid-virtualScroller": {
              backgroundColor: theme.palette.primary.light,
              fontSize:"16px"
            },
            "& .MuiDataGrid-footerContainer": {
              backgroundColor: theme.palette.background.alt,
              color: theme.palette.secondary[50],
              borderTop: "none",
              fontSize:"16px"
            },
            "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
              color: `${theme.palette.secondary[200]} !important`,
              fontSize:"16px"
            },
          }}
        >
          {console.log("dd", data)}
          <DataGrid
            loading={!data}
            getRowId={(row) => row.id}
            rows={(data?.data?.buses && data?.data?.buses) || []}
            columns={columns}
            rowCount={(data?.data?.buses && data?.data?.buses?.length) || 0}
            rowsPerPageOptions={[20, 50, 100]}
            page={page}
            onPageChange={(newPage) => setPage(newPage)}
          />
        </Box>
      </Box>
    </div>
  );
};

export default AddBus;
