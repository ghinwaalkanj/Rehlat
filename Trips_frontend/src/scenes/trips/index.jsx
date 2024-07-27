import { Box, Button, Modal, Typography, useTheme } from "@mui/material";
import React, { useEffect, useState } from "react";
import { DataGrid } from "@mui/x-data-grid";
import { useCancelTripMutation, useGetTripsQuery } from "state/api";
import Header from "components/Header";
import DataGridCustomToolbar from "components/DataGridCustomToolbar";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { toast } from "react-toastify";
import { decodeToken } from "react-jwt";
import { useSelector } from "react-redux";

const Trips = () => {
  const [t, i18n] = useTranslation();
  const theme = useTheme();
  const navigate = useNavigate();
  const { data, isLoading } = useGetTripsQuery();
  // console.log('data',data.data[0]);
  const [page, setPage] = useState(0);
  // values to be sent to the backend
  const [
    cancelTrip,
    { data: dataCanceled, isSuccess, isLoading: isDeleteBusLoading, error },
  ] = useCancelTripMutation();
  const [openReservation, setOpenReservation] = React.useState(false);
  const handleConfirmClose = () => setOpenReservation(false);
  const [idToDelete, setIdToDelete] = useState(null);
  const onConfirmClicked = async () => {
    await cancelTrip(idToDelete);
    setOpenReservation(false);
  };
  const token = useSelector((state) => state.global.token);

  let decodedToken = null;
  if (token) {
    decodedToken = decodeToken(token) ?? null;
  }

  const isAll = Boolean(decodedToken?.roles?.includes("all"));
  const isCanControlTrips = Boolean(
    decodedToken?.roles?.includes("trips_control")
  );

  useEffect(() => {
    console.log("data", data);
    console.log("error", error);
    console.log("isLoading", isLoading);
    if (isSuccess) {
      toast.success("Success!");
    } else if (error) {
      toast.error(error.data.message);
    }
  }, [dataCanceled, error, isDeleteBusLoading]);

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
  const columns = [
    {
      field: "unique_id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "source",
      headerName: "من",
      flex: 1,
    },
    {
      field: "destination",
      headerName: "إلى",
      flex: 1,
    },
    {
      field: "start_date",
      headerName: "موعد الرحلة",
      flex: 1,
    },
    {
      field: "bus_type",
      headerName: "نوع الباص",
      flex: 1,
    },
    {
      field: "seats_leaft",
      headerName: "المتبقي",
      flex: 1,
    },
    {
      field: "actions",
      headerName: "Actions",
      width: 180,
      renderCell: (params) =>
        !params.row.is_cancel ? (
          <div>
            <Box
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
                onClick={() => navigate(`/trips/${params.id}?show=1`)}
                variant="outlined"
              >
                {t("show")}
              </Button>
            </Box>
            {(isAll || isCanControlTrips) && (
              <Button
                variant="outlined"
                onClick={() => {
                  setIdToDelete(params.id);
                  setOpenReservation(true);
                }}
                color="error"
              >
                انهاء
              </Button>
            )}
          </div>
        ) : (
          <div>رحلة ملغاة</div>
        ),
    },
    // {
    //   field: "products",
    //   headerName: "# of Products",
    //   flex: 0.5,
    //   sortable: false,
    //   renderCell: (params) => params.value.length,
    // },
    // {
    //   field: "cost",
    //   headerName: "Cost",
    //   flex: 1,
    //   renderCell: (params) => `$${Number(params.value).toFixed(2)}`,
    // },
  ];

  return (
    <Box m="1.5rem 2.5rem">
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
              Are you sure finish this trip?
            </Typography>

            <Button color="success" onClick={handleConfirmClose}>
              NO
            </Button>
            <Button color="error" onClick={onConfirmClicked}>
              Yes
            </Button>
          </Box>
        </div>
      </Modal>
      <Header title={t("trips")} subtitle={t("trips_for_15_days")} />
      <Box
        height="80vh"
        sx={{
          "& .MuiDataGrid-root": {
            border: "none",
          },
          "& .MuiDataGrid-cell": {
            borderBottom: `1px solid ${theme.palette.secondary[50]}`,
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
            color: theme.palette.secondary[100],
            borderTop: "none",
            fontSize:"16px"
          },
          "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
            color: `${theme.palette.secondary[200]} !important`,
            fontSize:"16px"
          },
        }}
      >
        <DataGrid
          loading={isLoading || !data}
          getRowId={(row) => row.id}
          rows={(data && data.data) || []}
          columns={columns}
          rowCount={(data && data.data.length) || 0}
          rowsPerPageOptions={[20, 50, 100]}
          // pagination
          page={page}
          //pageSize={5}
          // paginationMode="server"
          // sortingMode="server"
          onPageChange={(newPage) => setPage(newPage)}
          // onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
          // onSortModelChange={(newSortModel) => setSort(...newSortModel)}
          // components={{ Toolbar: DataGridCustomToolbar }}
          // componentsProps={{
          //   toolbar: { searchInput, setSearchInput, setSearch },
          // }}
        />
      </Box>
    </Box>
  );
};

export default Trips;
