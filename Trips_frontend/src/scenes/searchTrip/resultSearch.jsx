import { Box, Button, Modal, Typography, useTheme } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import Header from "components/Header";
import React, { useEffect } from "react";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import { useNavigate } from "react-router-dom";
import { useCancelTripMutation, useFinishTripListMutation } from "state/api";
import { toast } from "react-toastify";

const ResultSearch = (props) => {
  console.log("props", props);
  const theme = useTheme();
  const [t, i18n] = useTranslation();
  const navigate = useNavigate();
  // const data = props.searchData;
  const [data, setData] = useState(props.searchData);
  // console.log('data',data.data[0]);
  const [page, setPage] = useState(0);
  const [idToDelete, setIdToDelete] = useState(null);
  const [
    cancelTrip,
    { data: dataCanceled, isSuccess, isLoading: isDeleteBusLoading, error },
  ] = useCancelTripMutation();
  const [openReservation, setOpenReservation] = React.useState(false);
  const handleConfirmClose = () => setOpenReservation(false);

  useEffect(() => {
    console.log("isSuccess");
    if (isSuccess) {
      const updatedData = data.map((item) =>
        item.id === idToDelete
          ? {
              ...item,
              is_cancel: true,
            }
          : item
      );
      setData(updatedData);
    } else if (error) {
      toast.error("لايمكن حذف هذه الرحلة لأن بها حجوزات");
    }
  }, [isSuccess,error]);
  const onConfirmClicked = async () => {
    await cancelTrip(idToDelete);

    setOpenReservation(false);
  };
  // values to be sent to the backend
  // const [page, setPage] = useState(0);
  // const [pageSize, setPageSize] = useState(20);
  // const [searchInput, setSearchInput] = useState("");
  const columns = [
    {
      field: "id",
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
                onClick={() => navigate(`/trips/${params.id}`)}
                variant="outlined"
              >
                {t("show")}
              </Button>
            </Box>
            {console.log("rrrr", params.row)}
            {!props.isCanPayment && (
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
  ];
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
  return (
    <Box m="0.5rem 0.5rem">
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
              Are you sure delete this continue list?
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
      {/* <Header title="الرحلات" subtitle="قائمة الرحلات القادمة"  /> */}
      <Typography
        sx={{ textAlign: "center", marginBottom: "1rem" }}
        variant="h4"
      >
        نتائج البحث
      </Typography>
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
            fontSize: "16px",
          },
          "& .MuiDataGrid-virtualScroller": {
            backgroundColor: theme.palette.primary.light,
          },
          "& .MuiDataGrid-footerContainer": {
            backgroundColor: theme.palette.background.alt,
            color: theme.palette.secondary[50],
            borderTop: "none",
          },
          "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
            color: `${theme.palette.secondary[200]} !important`,
            fontSize: "16px",
          },
        }}
      >
        <DataGrid
          loading={!data}
          getRowId={(row) => row.id}
          rows={(data && data) || []}
          columns={columns}
          rowCount={(data && data.length) || 0}
          rowsPerPageOptions={[20, 50, 100]}
          page={page}
          onPageChange={(newPage) => setPage(newPage)}
        />
      </Box>
    </Box>
  );
};

export default ResultSearch;
