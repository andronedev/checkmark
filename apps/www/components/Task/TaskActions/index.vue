<template>
  <div
    v-click-outside="() => open = false"
    class="relative"
  >
    <button
      type="button"
      class="flex items-center justify-center border border-solid border-gray-300 dark:border-gray-600 dark:hover:bg-gray-600 w-8 h-8 rounded-full hover:bg-gray-200"
      @click="open = true"
    >
      <more-horizontal-icon
        size="20"
        class="text-gray-600 dark:text-gray-300"
      />
    </button>
    <transition
      name="fade"
    >
      <ul
        v-if="open"
        class="absolute right-0 bg-white dark:bg-gray-600 dark:text-white rounded border border-solid border-gray-300 dark:border-gray-600 p-3 shadow-lg z-10"
      >
        <li class="mb-2">
          <button
            :disabled="$wait.is(`editing task ${task.uuid}`)"
            type="button"
            class="w-full text-left text-sm py-2 px-3 rounded hover:bg-gray-200 dark:hover:bg-gray-500"
            @click="editTask"
          >
            {{ $trans('home.buttons.edit') }}
          </button>
        </li>
        <li>
          <button
            :disabled="$wait.is(`deleting task ${task.uuid}`)"
            type="button"
            class="w-full text-left text-sm py-2 px-3 rounded hover:bg-gray-200 dark:hover:bg-gray-500 text-red-600 dark:bg-red-400 dark:bg-opacity-25 dark:hover:bg-red-400 dark:text-white"
            @click="removeTask"
          >
            {{ $trans('home.buttons.delete') }}
          </button>
        </li>
      </ul>
    </transition>
  </div>
</template>

<script lang="ts">
  import { defineComponent, ref, toRefs } from '@nuxtjs/composition-api'
  import { MoreHorizontalIcon } from 'vue-feather-icons'
  import useAxios from '~/composables/useAxios'
  import useWait from '~/composables/useWait'
  import useToasted from '~/composables/useToasted'
  import useMitt from '~/composables/useMitt'
  import useICU from '~/composables/useICU'
  import { Task } from '~/types/task'

  export default defineComponent({
    components: {
      MoreHorizontalIcon
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const open = ref(false)
      const { task } = toRefs(props)

      const wait = useWait()
      const axios = useAxios()
      const toasted = useToasted()
      const mitt = useMitt()
      const trans = useICU()

      function removeTask () {
        if (window.confirm(trans('home.paragraphs.confirm_task_deletion'))) {
          wait.start(`deleting task ${task.value.uuid}`)
          axios.delete(`/me/tasks/${task.value.uuid}`)
            .then(() => {
              toasted.success(trans('home.paragraphs.task_deleted'))
              mitt.emit('update-tasks')
            })
            .finally(() => {
              open.value = false
              wait.end(`deleting task ${task.value.uuid}`)
            })
        }
      }

      function editTask () {
        mitt.emit(`edit dialog for ${task.value.uuid}`, task.value)
      }

      return {
        open,
        removeTask,
        editTask
      }
    }
  })
</script>
