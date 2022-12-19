require('neorg').setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          work = "~/Notes/Work",
          home = "~/Notes/Home",
        },
      }
    },
    ["core.norg.concealer"] = {},
    -- ["core.gtd.base"] = {},
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      },
    }
    -- ["core.export"] = {},
    -- ["core.norg.manoeuvre"] = {},
  }
}
