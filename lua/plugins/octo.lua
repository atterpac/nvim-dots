return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = {
      {
        "<localleader>k",
        function()
          local keymaps = {
            { key = "\\k", desc = "Show this help" },
            { key = "\\b", desc = "Open in browser" },
            { key = "\\y", desc = "Copy URL" },
            { key = "\\r", desc = "Reload" },
            { key = "\\x", desc = "Close review tab" },
            { key = "", desc = "── Reviews ──" },
            { key = "\\vs", desc = "Start/submit review" },
            { key = "\\vr", desc = "Resume review" },
            { key = "\\vd", desc = "Discard review / remove reviewer" },
            { key = "\\va", desc = "Add reviewer" },
            { key = "\\m", desc = "Toggle file viewed" },
            { key = "\\M", desc = "Mark viewed + next unviewed" },
            { key = "", desc = "── Comments (n/v mode) ──" },
            { key = "\\ca", desc = "Add comment (select lines in visual)" },
            { key = "\\cd", desc = "Delete comment" },
            { key = "\\sa", desc = "Add suggestion (select lines in visual)" },
            { key = "]c / [c", desc = "Next/prev comment" },
            { key = "]t / [t", desc = "Next/prev thread" },
            { key = "\\ct", desc = "Show thread under cursor" },
            { key = "", desc = "── Navigation ──" },
            { key = "\\e", desc = "Focus file panel" },
            { key = "\\t", desc = "Toggle file panel" },
            { key = "]q / [q", desc = "Next/prev changed file" },
            { key = "]u / [u", desc = "Next/prev unviewed file" },
            { key = "", desc = "── PR Actions ──" },
            { key = "\\po", desc = "Checkout PR" },
            { key = "\\pm", desc = "Merge PR" },
            { key = "\\psm", desc = "Squash and merge PR" },
            { key = "\\prm", desc = "Rebase and merge PR" },
            { key = "\\pc", desc = "List PR commits" },
            { key = "\\pf", desc = "List changed files" },
            { key = "\\pd", desc = "Show PR diff" },
            { key = "", desc = "── Issues ──" },
            { key = "\\ic", desc = "Close issue/PR" },
            { key = "\\io", desc = "Reopen issue/PR" },
            { key = "\\il", desc = "List open issues" },
            { key = "\\gi", desc = "Go to issue" },
            { key = "", desc = "── Assignees & Labels ──" },
            { key = "\\aa", desc = "Add assignee" },
            { key = "\\ad", desc = "Remove assignee" },
            { key = "\\la", desc = "Add label" },
            { key = "\\ld", desc = "Remove label" },
            { key = "\\lc", desc = "Create label" },
            { key = "", desc = "── Reactions ──" },
            { key = "\\r+", desc = "Thumbs up" },
            { key = "\\r-", desc = "Thumbs down" },
            { key = "\\rh", desc = "Heart" },
            { key = "\\rr", desc = "Rocket" },
            { key = "\\rp", desc = "Hooray" },
            { key = "\\re", desc = "Eyes" },
            { key = "\\rl", desc = "Laugh" },
            { key = "\\rc", desc = "Confused" },
            { key = "", desc = "── Submit Review ──" },
            { key = "\\a", desc = "Approve review" },
            { key = "\\c", desc = "Comment review" },
            { key = "\\r", desc = "Request changes" },
          }
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local telescope_actions = require("telescope.actions")

          pickers
            .new({}, {
              prompt_title = "Octo Keymaps",
              finder = finders.new_table({
                results = keymaps,
                entry_maker = function(entry)
                  local display = entry.key ~= "" and string.format("%-12s %s", entry.key, entry.desc) or entry.desc
                  return {
                    value = entry,
                    display = display,
                    ordinal = entry.desc,
                  }
                end,
              }),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr)
                telescope_actions.select_default:replace(function()
                  telescope_actions.close(prompt_bufnr)
                end)
                return true
              end,
            })
            :find()
        end,
        desc = "Octo keymaps",
      },
    },
    config = function()
      -- Custom keymaps for octo buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "octo", "octo_panel" },
        callback = function()
          -- Mark viewed and advance to next unviewed file
          vim.keymap.set("n", "<localleader>M", function()
            local ok, reviews = pcall(require, "octo.reviews")
            if ok then
              local layout = reviews.get_current_layout()
              if layout then
                layout:toggle_viewed()
              end
            end
            vim.schedule(function()
              vim.api.nvim_feedkeys("]u", "n", false)
            end)
          end, { buffer = true, desc = "Mark viewed and next file" })

          -- Show thread under cursor
          vim.keymap.set("n", "<localleader>ct", function()
            local ok, thread_panel = pcall(require, "octo.reviews.thread-panel")
            if ok then
              thread_panel.show_review_threads(true)
            end
          end, { buffer = true, desc = "Show comment thread" })
        end,
      })

      -- In thread buffer, Esc or h at boundary returns to diff
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "octo_thread",
        callback = function()
          vim.keymap.set("n", "<Esc>", function()
            vim.cmd("wincmd h")
          end, { buffer = true, desc = "Back to diff" })

          -- h goes back to diff
          vim.keymap.set("n", "h", function()
            vim.cmd("wincmd h")
          end, { buffer = true, desc = "Back to diff" })

          -- j/k wrap to diff when at boundaries
          vim.keymap.set("n", "j", function()
            local line = vim.fn.line(".")
            local last = vim.fn.line("$")
            if line >= last then
              vim.cmd("wincmd h")
            else
              vim.cmd("normal! j")
            end
          end, { buffer = true, desc = "Down or back to diff" })

          vim.keymap.set("n", "k", function()
            local line = vim.fn.line(".")
            if line <= 1 then
              vim.cmd("wincmd h")
            else
              vim.cmd("normal! k")
            end
          end, { buffer = true, desc = "Up or back to diff" })
        end,
      })

      require("octo").setup({
        use_local_fs = false,
        enable_builtin = true,
        default_remote = { "upstream", "origin" },
        default_merge_method = "merge",
        default_delete_branch = false,
        ssh_aliases = {},
        picker = "telescope",
        picker_config = {
          use_emojis = false,
          search_static = true,
          mappings = {
            open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            copy_sha = { lhs = "<C-e>", desc = "copy commit SHA to system clipboard" },
            checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
            merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
          },
        },
        comment_icon = "▎",
        outdated_icon = "󰅒 ",
        resolved_icon = " ",
        reaction_viewer_hint_icon = " ",
        user_icon = " ",
        ghost_icon = "󰊠 ",
        copilot_icon = " ",
        timeline_marker = " ",
        timeline_indent = 2,
        use_timeline_icons = true,
        timeline_icons = {
          commit = "  ",
          label = "  ",
          reference = " ",
          connected = "  ",
          subissue = "  ",
          cross_reference = "  ",
          parent_issue = "  ",
          pinned = "  ",
          milestone = "  ",
          renamed = "  ",
          merged = { "  ", "OctoPurple" },
          closed = {
            closed = { "  ", "OctoRed" },
            completed = { "  ", "OctoPurple" },
            not_planned = { "  ", "OctoGrey" },
            duplicate = { "  ", "OctoGrey" },
          },
          reopened = { "  ", "OctoGreen" },
          assigned = "  ",
          review_requested = "  ",
        },
        right_bubble_delimiter = "",
        left_bubble_delimiter = "",
        github_hostname = "",
        snippet_context_lines = 4,
        gh_cmd = "gh",
        gh_env = {},
        timeout = 5000,
        default_to_projects_v2 = false,
        ui = {
          use_signcolumn = false,
          use_signstatus = true,
        },
        issues = {
          order_by = {
            field = "CREATED_AT",
            direction = "DESC",
          },
        },
        reviews = {
          auto_show_threads = true,
          focus = "right",
        },
        runs = {
          icons = {
            pending = "🕖",
            in_progress = "🔄",
            failed = "❌",
            succeeded = "",
            skipped = "⏩",
            cancelled = "✖",
          },
        },
        pull_requests = {
          order_by = {
            field = "CREATED_AT",
            direction = "DESC",
          },
          always_select_remote_on_create = false,
          use_branch_name_as_title = false,
        },
        notifications = {
          current_repo_only = false,
        },
        file_panel = {
          size = 10,
          use_icons = true,
        },
        colors = {
          white = "#ffffff",
          grey = "#2A354C",
          black = "#000000",
          red = "#fdb8c0",
          dark_red = "#da3633",
          green = "#acf2bd",
          dark_green = "#238636",
          yellow = "#d3c846",
          dark_yellow = "#735c0f",
          blue = "#58A6FF",
          dark_blue = "#0366d6",
          purple = "#6f42c1",
        },
        mappings_disable_default = false,
        mappings = {
          issue = {
            close_issue = { lhs = "<localleader>ic", desc = "close issue" },
            reopen_issue = { lhs = "<localleader>io", desc = "reopen issue" },
            list_issues = { lhs = "<localleader>il", desc = "list open issues" },
            reload = { lhs = "<localleader>r", desc = "reload issue" },
            open_in_browser = { lhs = "<localleader>b", desc = "open in browser" },
            copy_url = { lhs = "<localleader>y", desc = "copy url" },
            add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
            create_label = { lhs = "<localleader>lc", desc = "create label" },
            add_label = { lhs = "<localleader>la", desc = "add label" },
            remove_label = { lhs = "<localleader>ld", desc = "remove label" },
            goto_issue = { lhs = "<localleader>gi", desc = "go to issue" },
            add_comment = { lhs = "<localleader>ca", desc = "add comment" },
            delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "next comment" },
            prev_comment = { lhs = "[c", desc = "prev comment" },
            react_hooray = { lhs = "<localleader>rp", desc = "react hooray" },
            react_heart = { lhs = "<localleader>rh", desc = "react heart" },
            react_eyes = { lhs = "<localleader>re", desc = "react eyes" },
            react_thumbs_up = { lhs = "<localleader>r+", desc = "react thumbs up" },
            react_thumbs_down = { lhs = "<localleader>r-", desc = "react thumbs down" },
            react_rocket = { lhs = "<localleader>rr", desc = "react rocket" },
            react_laugh = { lhs = "<localleader>rl", desc = "react laugh" },
            react_confused = { lhs = "<localleader>rc", desc = "react confused" },
          },
          pull_request = {
            checkout_pr = { lhs = "<localleader>po", desc = "checkout PR" },
            merge_pr = { lhs = "<localleader>pm", desc = "merge PR" },
            squash_and_merge_pr = { lhs = "<localleader>psm", desc = "squash and merge PR" },
            rebase_and_merge_pr = { lhs = "<localleader>prm", desc = "rebase and merge PR" },
            list_commits = { lhs = "<localleader>pc", desc = "list PR commits" },
            list_changed_files = { lhs = "<localleader>pf", desc = "list changed files" },
            show_pr_diff = { lhs = "<localleader>pd", desc = "show PR diff" },
            add_reviewer = { lhs = "<localleader>va", desc = "add reviewer" },
            remove_reviewer = { lhs = "<localleader>vd", desc = "remove reviewer" },
            close_issue = { lhs = "<localleader>ic", desc = "close PR" },
            reopen_issue = { lhs = "<localleader>io", desc = "reopen PR" },
            list_issues = { lhs = "<localleader>il", desc = "list open issues" },
            reload = { lhs = "<localleader>r", desc = "reload PR" },
            open_in_browser = { lhs = "<localleader>b", desc = "open in browser" },
            copy_url = { lhs = "<localleader>y", desc = "copy url" },
            goto_file = { lhs = "gf", desc = "go to file" },
            add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
            create_label = { lhs = "<localleader>lc", desc = "create label" },
            add_label = { lhs = "<localleader>la", desc = "add label" },
            remove_label = { lhs = "<localleader>ld", desc = "remove label" },
            goto_issue = { lhs = "<localleader>gi", desc = "go to issue" },
            add_comment = { lhs = "<localleader>ca", desc = "add comment" },
            delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "next comment" },
            prev_comment = { lhs = "[c", desc = "prev comment" },
            react_hooray = { lhs = "<localleader>rp", desc = "react hooray" },
            react_heart = { lhs = "<localleader>rh", desc = "react heart" },
            react_eyes = { lhs = "<localleader>re", desc = "react eyes" },
            react_thumbs_up = { lhs = "<localleader>r+", desc = "react thumbs up" },
            react_thumbs_down = { lhs = "<localleader>r-", desc = "react thumbs down" },
            react_rocket = { lhs = "<localleader>rr", desc = "react rocket" },
            react_laugh = { lhs = "<localleader>rl", desc = "react laugh" },
            react_confused = { lhs = "<localleader>rc", desc = "react confused" },
            review_start = { lhs = "<localleader>vs", desc = "start review" },
            review_resume = { lhs = "<localleader>vr", desc = "resume review" },
          },
          review_thread = {
            goto_issue = { lhs = "<localleader>gi", desc = "go to issue" },
            add_comment = { lhs = "<localleader>ca", desc = "add comment" },
            add_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
            delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "next comment" },
            prev_comment = { lhs = "[c", desc = "prev comment" },
            select_next_entry = { lhs = "]q", desc = "next changed file" },
            select_prev_entry = { lhs = "[q", desc = "prev changed file" },
            select_first_entry = { lhs = "[Q", desc = "first changed file" },
            select_last_entry = { lhs = "]Q", desc = "last changed file" },
            close_review_tab = { lhs = "<localleader>x", desc = "close review tab" },
            react_hooray = { lhs = "<localleader>rp", desc = "react hooray" },
            react_heart = { lhs = "<localleader>rh", desc = "react heart" },
            react_eyes = { lhs = "<localleader>re", desc = "react eyes" },
            react_thumbs_up = { lhs = "<localleader>r+", desc = "react thumbs up" },
            react_thumbs_down = { lhs = "<localleader>r-", desc = "react thumbs down" },
            react_rocket = { lhs = "<localleader>rr", desc = "react rocket" },
            react_laugh = { lhs = "<localleader>rl", desc = "react laugh" },
            react_confused = { lhs = "<localleader>rc", desc = "react confused" },
          },
          submit_win = {
            approve_review = { lhs = "<localleader>a", desc = "approve review" },
            comment_review = { lhs = "<localleader>c", desc = "comment review" },
            request_changes = { lhs = "<localleader>r", desc = "request changes" },
            close_review_tab = { lhs = "<localleader>x", desc = "close review tab" },
          },
          review_diff = {
            submit_review = { lhs = "<localleader>vs", desc = "submit review" },
            discard_review = { lhs = "<localleader>vd", desc = "discard review" },
            add_review_comment = { lhs = "<localleader>ca", desc = "add review comment", mode = { "n", "v" } },
            add_review_suggestion = { lhs = "<localleader>sa", desc = "add review suggestion", mode = { "n", "v" } },
            focus_files = { lhs = "<localleader>e", desc = "focus file panel" },
            toggle_files = { lhs = "<localleader>t", desc = "toggle file panel" },
            next_thread = { lhs = "]t", desc = "next thread" },
            prev_thread = { lhs = "[t", desc = "prev thread" },
            select_next_entry = { lhs = "]q", desc = "next changed file" },
            select_prev_entry = { lhs = "[q", desc = "prev changed file" },
            select_first_entry = { lhs = "[Q", desc = "first changed file" },
            select_last_entry = { lhs = "]Q", desc = "last changed file" },
            select_next_unviewed_entry = { lhs = "]u", desc = "next unviewed file" },
            select_prev_unviewed_entry = { lhs = "[u", desc = "prev unviewed file" },
            close_review_tab = { lhs = "<localleader>x", desc = "close review tab" },
            toggle_viewed = { lhs = "<localleader>m", desc = "toggle viewed" },
          },
          file_panel = {
            submit_review = { lhs = "<localleader>vs", desc = "submit review" },
            discard_review = { lhs = "<localleader>vd", desc = "discard review" },
            next_entry = { lhs = "j", desc = "next file" },
            prev_entry = { lhs = "k", desc = "prev file" },
            select_entry = { lhs = "<cr>", desc = "show diff" },
            refresh_files = { lhs = "R", desc = "refresh files" },
            focus_files = { lhs = "<localleader>e", desc = "focus file panel" },
            toggle_files = { lhs = "<localleader>t", desc = "toggle file panel" },
            select_next_entry = { lhs = "]q", desc = "next changed file" },
            select_prev_entry = { lhs = "[q", desc = "prev changed file" },
            select_first_entry = { lhs = "[Q", desc = "first changed file" },
            select_last_entry = { lhs = "]Q", desc = "last changed file" },
            select_next_unviewed_entry = { lhs = "]u", desc = "next unviewed file" },
            select_prev_unviewed_entry = { lhs = "[u", desc = "prev unviewed file" },
            close_review_tab = { lhs = "<localleader>x", desc = "close review tab" },
            toggle_viewed = { lhs = "<localleader>m", desc = "toggle viewed" },
          },
        },
      })
    end,
  },
}
