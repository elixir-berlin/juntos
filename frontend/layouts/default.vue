<template>
  <v-app light>
 
    <v-content>
      <v-container>
        <nuxt />
      </v-container>
    </v-content>

    <v-footer app>
      <span>footer
       <v-switch label="Dark Mode" @change="toggleDarkMode()"/>
      </span>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  created() {
    this.$store.dispatch('authProvider/all')
  },
  methods: {
    toggleDarkMode() {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark
    }
  }
}
</script>
