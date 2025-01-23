<template>
    <div id="app">
        <CurrencyConverter />
    </div>
</template>

<script>
    import CurrencyConverter from "./components/CurrencyConverter.vue";
    export default {
        components: {
            CurrencyConverter,
        },
    };
</script>

<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
</style>
