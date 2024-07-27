import { Avatar, Box, Button, Typography, useTheme } from "@mui/material";
import React, { useState } from "react";
import { DataGrid } from "@mui/x-data-grid";
import {
  useActiveOrInactiveCompanyUserByIdMutation,
  useGetClaimsQuery,
  useGetCompaniesQuery,
  useGetCompanyUsersQuery,
  useGetTripListQuery,
} from "state/api";
import Header from "components/Header";
import DataGridCustomToolbar from "components/DataGridCustomToolbar";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { toast } from "react-toastify";

const GetCompanyUser = () => {
  const [t, i18n] = useTranslation();
  const theme = useTheme();
  const navigate = useNavigate();
  //   const { data, isLoading } = useGetTripsQuery();
  const [page, setPage] = useState(0);
  const { data, isLoading } = useGetCompanyUsersQuery();
  const [activeUser, { data: dataActive, isError, error, isSuccess }] =
    useActiveOrInactiveCompanyUserByIdMutation();
  console.log("data", data);

  const handleActiveClicked = async (id) => {
    await activeUser(id);
    toast.success("Success!");
    navigate("/get_company_user");
  };
  const columns = [
    {
      field: "id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "name",
      headerName: "الاسم ",
      flex: 1,
    },
    {
      field: "username",
      headerName: "اسم المستخدم ",
      flex: 1,
    },
    {
      field: "permissions",
      headerName: "الصلاحيات",
      flex: 1,
      renderCell: (params) => (
        <Box>
          {params.row.roles.map((role, index) => (
            <Typography key={index} variant="p">
              {role} {index !== params.row.roles.length - 1 ? " - " : ""}
            </Typography>
          ))}
        </Box>
      ),
    },
    {
      field: "actions",
      headerName: "Actions",
      width: 180,
      renderCell: (params) => (
        <div>
          <Box
            display="inline-block"
            sx={{
              "& .MuiButton-outlined:first-child": {
                borderColor: theme.palette.secondary[300] + "!important",
                color: theme.palette.secondary[300],
              },
            }}
          >
            <Button
              sx={{ marginLeft: "12px" }}
              onClick={() => navigate(`/get_company_user/${params.id}`)}
              variant="outlined"
              // color={theme.palette.secondary[300]}
            >
              {t("show")}
            </Button>
            <Button
              sx={{ marginLeft: "12px" }}
              onClick={() => handleActiveClicked(params.id)}
              variant="outlined"
              color={
                Boolean(params.row.is_active) === true ? "warning" : "info"
              }
            >
              {Boolean(params.row.is_active) === true
                ? "الغاء التفعيل"
                : "تفعيل"}
            </Button>
          </Box>
        </div>
      ),
    },
  ];

  return (
    <Box m="1.5rem 2.5rem">
      <Box mb="2rem" display="flex" justifyContent="space-between">
        <Header title="المستخدمين" />
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
            sx={{ marginLeft: "12px", fontSize: "16px" }}
            onClick={() => navigate(`/add_user`)}
            variant="outlined"
          >
            اضافة مستخدم جديد
          </Button>
        </Box>
      </Box>
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
          },
          "& .MuiDataGrid-virtualScroller": {
            backgroundColor: theme.palette.primary.light,
            color: theme.palette.secondary[50],
          },
          "& .MuiDataGrid-footerContainer": {
            backgroundColor: theme.palette.background.alt,
            color: theme.palette.secondary[50],
            borderTop: "none",
          },
          "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
            color: `${theme.palette.secondary[50]} !important`,
          },
        }}
      >
        <DataGrid
          loading={isLoading || !data}
          getRowId={(row) => row.id}
          rows={(data && data?.data?.users) || []}
          columns={columns}
          rowCount={(data && data?.data?.users.length) || 0}
          rowsPerPageOptions={[data?.data?.users?.length]}
          page={page}
          onPageChange={(newPage) => setPage(newPage)}
        />
      </Box>
    </Box>
  );
};

export default GetCompanyUser;
