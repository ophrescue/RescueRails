import { expect } from 'chai'
import { shallowMount } from '@vue/test-utils'
import App from '../../app/javascript/packs/components/app.vue'

describe('app.vue', () => {
  it('shows the dogs message', () => {
    const wrapper = shallowMount(App)
    expect(wrapper.find('p').text()).contains('who let the dogs out')
  })
})
