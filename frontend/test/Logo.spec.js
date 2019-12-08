/*
import { mount } from '@vue/test-utils'
import Logo from '@/components/Logo.vue'

describe('Logo', () => {
  test('is a Vue instance', () => {
    const wrapper = mount(Logo)
    expect(wrapper.isVueInstance()).toBeTruthy()
  })
})
*/

import { createLocalVue, shallowMount } from '@vue/test-utils'
import App from '@/pages/index.vue'
