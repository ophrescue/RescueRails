import { expect } from 'chai'
import { shallowMount } from '@vue/test-utils'
import App from '../../app/javascript/app.vue'

describe('app.vue', () => {
  it('shows the Hello Vue message', () => {
    const wrapper = shallowMount(App)
    expect(wrapper.find('p').text()).contains('Hello Vue!')
  })
})
