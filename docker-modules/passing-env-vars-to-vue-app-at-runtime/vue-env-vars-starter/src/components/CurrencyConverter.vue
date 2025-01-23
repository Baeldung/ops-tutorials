<script setup>
    import { ref, onMounted } from "vue";
    import { getExchangeRates } from "../api/exchangeRateApi";

    const amount = ref(null);
    const fromCurrency = ref("USD");
    const toCurrency = ref("EUR");
    const currencies = ref([]);
    const convertedAmount = ref(null);

    // Fallback data to use when fetching currencies fails
    const fallbackCurrencies = [
        "USD",
        "EUR",
        "GBP",
        "JPY",
        "AUD",
        "CAD",
        "CHF",
        "CNY",
        "INR",
        "NZD",
    ];

    const fetchCurrencies = async () => {
        try {
            const data = await getExchangeRates();
            if (data && data.conversion_rates) {
                currencies.value = Object.keys(data.conversion_rates);
            } else {
                throw new Error("Invalid data format");
            }
        } catch (error) {
            console.error("Error fetching currencies:", error);
            // Use fallback data
            currencies.value = fallbackCurrencies;
        }
    };

    const convertCurrency = async () => {
        try {
            const data = await getExchangeRates();
            console.log("Exchange rates data:", data);
            if (data && data.conversion_rates) {
                const fromRate = data.conversion_rates[fromCurrency.value];
                const toRate = data.conversion_rates[toCurrency.value];
                convertedAmount.value = (
                    (amount.value / fromRate) *
                    toRate
                ).toFixed(2);
                // Clear the input fields after successful conversion
                amount.value = null;
            } else {
                throw new Error("Invalid data format");
            }
        } catch (error) {
            console.error("Error converting currency:", error);
        }
    };

    onMounted(fetchCurrencies);
</script>

<template>
    <div class="currency-converter">
        <h1>Currency Converter</h1>
        <div class="converter-form">
            <input type="number" v-model="amount" placeholder="Enter amount" />
            <select v-model="fromCurrency">
                <option
                    v-for="currency in currencies"
                    :key="currency"
                    :value="currency"
                >
                    {{ currency }}
                </option>
            </select>
            <span>to</span>
            <select v-model="toCurrency">
                <option
                    v-for="currency in currencies"
                    :key="currency"
                    :value="currency"
                >
                    {{ currency }}
                </option>
            </select>
            <button @click="convertCurrency">Convert</button>
        </div>
        <p v-if="convertedAmount" class="converted-amount">
            Converted Amount: {{ convertedAmount }}
        </p>
    </div>
</template>

<style scoped>
    .currency-converter {
        max-width: 400px;
        margin: 20px auto;
        text-align: center;
        font-family: Arial, sans-serif;
    }

    .converter-form {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .converter-form input,
    .converter-form select,
    .converter-form button {
        padding: 10px;
        font-size: 16px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .converter-form button {
        background-color: #007bff;
        color: white;
        cursor: pointer;
    }

    .converter-form button:hover {
        background-color: #0056b3;
    }

    .converted-amount {
        margin-top: 20px;
        font-size: 22px;
        font-weight: bold;
        color: #12e343;
    }
</style>
