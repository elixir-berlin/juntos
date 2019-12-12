<template>
  <v-app light>
    <v-content>
      <v-container>
        <nuxt />
      </v-container>
    </v-content>

    <v-footer app>
      <span
        >footer
        <v-switch @change="toggleDarkMode()" label="Dark Mode" />
      </span>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  created() {
    this.$store.dispatch('authProvider/all', this.$apolloProvider.defaultClient)
  },
  methods: {
    toggleDarkMode() {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark
    }
  }
}
</script>
