import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from '@/pages/index.vue'
import User from '@/pages/user/index.vue'


Vue.use(VueRouter)


const WEBSITE_ROUTES = [
  {
    name: 'Home',
    path: '/',
    component: Home
  },
  {
    name: 'User',
    path: '/u/:username',
    component: User
  }
]

export function createRouter() {
  const router = new VueRouter({
    mode: 'history',
    routes: [
      ...WEBSITE_ROUTES,
      // {
      //   name: 'NotFound',
      //   component: NotFound,
      //   path: '*'
      // }
    ],
    scrollBehavior: () => ({ x: 0, y: 0 })
  })

  return router
}
