import { Box, Typography, useTheme, useMediaQuery } from "@mui/material";
import Form from "./Form";
import logo from "../../assets/logo.png";
const LoginPage = () => {
  const theme = useTheme();
  const isNonMobileScreens = useMediaQuery("(min-width: 1000px)");
  return (
    <Box>
      <Box
        width="100%"
        backgroundColor={theme.palette.background.alt}
        p="1rem 6%"
        textAlign="center"
      >
        <Typography
          fontWeight="bold"
          fontSize="32px"
          color={theme.palette.secondary[50]}
        >
          Trips
        </Typography>
      </Box>

      <Box
        width={isNonMobileScreens ? "50%" : "93%"}
        p="2rem"
        m="2rem auto"
        borderRadius="1.5rem"
        // backgroundColor={theme.palette.background.alt}
      >
        <Typography
          fontWeight="500"
          variant="h2"
          color={theme.palette.secondary[50]}
          sx={{ mb: "1.5rem", textAlign: "center" }}
        >
          Welcome to Trips
        </Typography>
        <Form />
      </Box>
      <img
        src={logo}
        alt="tests"
        style={{
          width: "10rem",
          position: "absolute",
          top: "4rem",
          right: "2rem",
          borderRadius:"50%",
          marginTop:"2rem"
        }}
      />
    </Box>
  );
};

export default LoginPage;
