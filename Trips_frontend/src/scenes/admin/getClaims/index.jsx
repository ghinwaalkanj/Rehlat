import {
  Box,
  Button,
  Modal,
  Typography,
  useTheme,
  TextField,
} from "@mui/material";
import React, { useState } from "react";
import { DataGrid } from "@mui/x-data-grid";
import {
  useGetClaimsQuery,
  useChangeStatusClaimMutation,
  useAnswerClaimMutation,
} from "state/api";
import Header from "components/Header";
import DataGridCustomToolbar from "components/DataGridCustomToolbar";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";

const GetClaims = () => {
  const [t, i18n] = useTranslation();
  const theme = useTheme();
  const navigate = useNavigate();
  //   const { data, isLoading } = useGetTripsQuery();
  const [page, setPage] = useState(0);
  const { data, isLoading } = useGetClaimsQuery({
    page: page + 1,
  });
  console.log("data", data);
  const [openReservation, setOpenReservation] = React.useState(false);
  const [idToDelete, setIdToDelete] = useState(null);
  const [messageAnswer, setMessageAnswer] = useState("");
  const [
    changeStatus,
    { data: dataChangeStatus, isLoading: changeStatusIsLoading },
  ] = useChangeStatusClaimMutation();
  const [
    answerClaim,
    { data: dataAnswerClaim, isLoading: AnswerClaimIsLoading },
  ] = useAnswerClaimMutation();

  const changeStatusClaimClicked = async (data) => {
    await changeStatus(data);
  };
  const columns = [
    {
      field: "id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "phone",
      headerName: "رقم الهاتف",
      flex: 2,
    },
    {
      field: "reservation_number",
      headerName: "رقم الحجز",
      flex: 1,
    },
    {
      field: "reservation_date",
      headerName: "تاريخ الحجز ",
      flex: 1,
      renderCell: (params) => {
        const dateTime = new Date(params.row.reservation_date);
        const hours = dateTime.getHours().toString().padStart(2, "0");
        const minutes = dateTime.getMinutes().toString().padStart(2, "0");
        const timeString = `${hours}:${minutes}`;
        return <Box>{dateTime.toLocaleDateString()}</Box>;
      },
    },
    {
      field: "status",
      headerName: "حالة الشكوى",
      flex: 1,
      renderCell: (params) => {
        return (
          <Box
            color={Boolean(params.row.status) ? "#4CAF50" : "#FFC107"}
            fontWeight="bold"
            fontSize="13px"
          >
            {Boolean(params.row.status) ? "تم حل المشكلة" : "معلقة"}
          </Box>
        );
      },
    },
    {
      field: "message",
      headerName: "الشكوى",
      flex: 2,
    },
    {
      field: "answer",
      headerName: "الرد",
      flex: 2,
    },

    {
      field: "actions",
      headerName: "Actions",
      width: 180,
      flex: 3,
      renderCell: (params) => (
        <div>
          <Button
            variant="outlined"
            onClick={() => {
              const data = {
                id: params.id,
                status: !params.row.status,
              };
              changeStatusClaimClicked(data);
            }}
            color={Boolean(params.row.status) === true ? "warning" : "success"}
          >
            {Boolean(params.row.status) === true ? "تعليق" : "تم الحل"}
          </Button>
          {!params.row.answer && (
            <Button
              variant="outlined"
              onClick={() => {
                setIdToDelete(params.id);
                setOpenReservation(true);
              }}
              color="info"
              sx={{ mr: "12px" }}
            >
              الرد
            </Button>
          )}
          {
            <Button
              variant="outlined"
              onClick={() => {
                setClaims(params.row.message);
                setResponseText(params.row.answer);
                setOpenMessage(true);
              }}
              color="warning"
              sx={{ mr: "12px" }}
            >
              عرض
            </Button>
          }
        </div>
      ),
    },
  ];
  const [pageSize, setPageSize] = useState(15);
  const styleModal = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 600,
    bgcolor: "#011819",
    border: "2px solid #011819",
    borderRadius:"15px",
    // boxShadow: 24,
    p: 4,
    textAlign: "right",
  };
  const onConfirmClicked = async () => {
    const data = {
      id: idToDelete,
      answer: messageAnswer,
    };
    await answerClaim(data);
    setOpenReservation(false);
  };
  const handleConfirmClose = () => setOpenReservation(false);

  const [claims, setClaims] = useState(null);
  const [responseText, setResponseText] = useState(null);
  const [openMessage, setOpenMessage] = React.useState(false);
  const handleConfirmCloseMessage = () => setOpenMessage(false);
  return (
    <Box m="1.5rem 2.5rem">
      <Header title="الشكاوى" />
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
              Write Your Message Here.
            </Typography>
            <TextField
              id="messageAnswer"
              label="Message"
              value={messageAnswer}
              onChange={(e) => setMessageAnswer(e.target.value)}
              fullWidth
              sx={{ mb: "1rem" }}
            />
            <Button color="info" onClick={handleConfirmClose}>
              Close
            </Button>
            <Button color="success" onClick={onConfirmClicked}>
              Send
            </Button>
          </Box>
        </div>
      </Modal>
      <Modal
        open={openMessage}
        onClose={handleConfirmCloseMessage}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <div>
          <Box sx={styleModal}>
            <Typography
              sx={{ mb: "1rem", fontWeight: "bold" }}
              id="modal-modal-title"
              variant="h2"
            >
              الشكوى
            </Typography>
            <Typography sx={{ mb: "2rem" }} id="modal-modal-title" variant="h5">
              {claims}
            </Typography>
            <Typography
              sx={{ mb: "1rem", fontWeight: "bold" }}
              id="modal-modal-title"
              variant="h2"
            >
              الرد
            </Typography>
            <Typography sx={{ mb: "1rem" }} id="modal-modal-title" variant="h5">
              {responseText || "لم يتم الرد بعد"}
            </Typography>
            <Button
              color="info"
              sx={{ fontSize: "20px" }}
              onClick={handleConfirmCloseMessage}
            >
              اغلاق
            </Button>
          </Box>
        </div>
      </Modal>
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
          loading={isLoading || !data}
          getRowId={(row) => row.id}
          rows={(data && data?.data?.claims?.data) || []}
          columns={columns}
          rowCount={(data && data?.data?.claims?.total) || 0}
          rowsPerPageOptions={[data?.data?.claims?.data?.length]}
          pagination
          page={page}
          pageSize={pageSize}
          onPageChange={(newPage) => setPage(newPage)}
          paginationMode="server"
          onPageSizeChange={(newPageSize) => setPageSize(newPageSize)}
        />
      </Box>
    </Box>
  );
};

export default GetClaims;
