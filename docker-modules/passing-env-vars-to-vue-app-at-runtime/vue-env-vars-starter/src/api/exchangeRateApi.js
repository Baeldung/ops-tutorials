import axios from "axios";

const API_URL =
    window.config?.VUE_APP_API_URL ||
    "https://v6.exchangerate-api.com/v6/YOUR_API_KEY/latest/USD";

export const getExchangeRates = async () => {
    console.log("====================================");
    console.log("API_URL", API_URL);
    console.log("====================================");
    const response = await axios.get(API_URL);
    return response.data;
};
