import React, { useState } from "react";
import {
  LightModeOutlined,
  DarkModeOutlined,
  Menu as MenuIcon,
  Search,
  SettingsOutlined,
  ArrowDropDownOutlined,
} from "@mui/icons-material";
import FlexBetween from "components/FlexBetween";
import { useDispatch } from "react-redux";
import { setMode, setLogout } from "state";
// import { useHistory } from "react-router-dom";

import {
  AppBar,
  Button,
  Box,
  Typography,
  IconButton,
  InputBase,
  Toolbar,
  Menu,
  MenuItem,
  useTheme,
} from "@mui/material";
import LanguageOutlinedIcon from "@mui/icons-material/LanguageOutlined";
import { useTranslation } from "react-i18next";
import { setCookie, getCookie, eraseCookie } from "../utils/helperFunction";
import logo from "../assets/logo.png";


const Navbar = ({ user, isSidebarOpen, setIsSidebarOpen }) => {
  const dispatch = useDispatch();
  // const history = useHistory();
  const theme = useTheme();
  const [t, i18n] = useTranslation();

  const [anchorEl, setAnchorEl] = useState(null);
  const isOpen = Boolean(anchorEl);
  const handleClick = (event) => setAnchorEl(event.currentTarget);
  const handleClose = () => setAnchorEl(null);

  return (
    <AppBar
      sx={{
        position: "static",
        background: "none",
        boxShadow: "none",
      }}
    >
      <Toolbar sx={{ justifyContent: "space-between" }}>
        {/* LEFT SIDE */}
        <FlexBetween>
          <IconButton onClick={() => setIsSidebarOpen(!isSidebarOpen)}>
            <MenuIcon />
          </IconButton>
        </FlexBetween>

        {/* RIGHT SIDE */}
        <img
        src={logo}
        alt="tests"
        style={{
          width: "5rem",
          // position: "absolute",
          // top: "4rem",
          // right: "2rem",
          borderRadius:"50%",
          marginTop:".5rem",
          transform:"translateX(-4rem)"
        }}
      />

        <FlexBetween gap="1.5rem">
          {/* <IconButton onClick={() => dispatch(setMode())}> */}
            {/* {theme.palette.mode === "dark" ? (
              <DarkModeOutlined sx={{ fontSize: "25px" }} />
            ) : (
              <LightModeOutlined sx={{ fontSize: "25px" }} />
            )} */}
          {/* </IconButton> */}
          {/* <IconButton>
            <SettingsOutlined sx={{ fontSize: "25px" }} />
          </IconButton> */}
          {/* <IconButton
            onClick={() => {
              return i18n.language === "en"
                ? i18n.changeLanguage("ar")
                : i18n.changeLanguage("en");
            }}
          >
            <LanguageOutlinedIcon sx={{ fontSize: "25px" }} />
          </IconButton> */}
          <Typography variant="h3" sx={{mt:"1rem"}}>{getCookie('name_ar')}</Typography>
          <Box
            component="img"
            alt="profile"
            src={getCookie("image")}
            height="3rem"
            width="3rem"
            borderRadius="50%"
            mt="0.5rem"
            sx={{ objectFit: "cover" }}
          />

          <FlexBetween>
            <Button
              onClick={handleClick}
              sx={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                textTransform: "none",
                gap: "1rem",
              }}
            >
              <Box textAlign="left">
                <Typography
                  fontWeight="bold"
                  fontSize="0.85rem"
                  sx={{ color: theme.palette.secondary[50] }}
                >
                  {user.name}
                </Typography>
                <Typography
                  fontSize="0.75rem"
                  sx={{ color: theme.palette.secondary[200] }}
                >
                  {user.occupation}
                </Typography>
              </Box>
              <ArrowDropDownOutlined
                sx={{ color: theme.palette.secondary[300], fontSize: "25px" }}
              />
            </Button>
            <Menu
              anchorEl={anchorEl}
              open={isOpen}
              onClose={handleClose}
              anchorOrigin={{ vertical: "bottom", horizontal: "center" }}
            >
              <MenuItem
                onClick={() => {
                  handleClose();
                  dispatch(setLogout());
                  window.history.replaceState({}, undefined, "/");
                }}
              >
                Log Out
              </MenuItem>
            </Menu>
          </FlexBetween>
        </FlexBetween>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;
