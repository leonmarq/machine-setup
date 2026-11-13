local snap_data_home = vim.env.XDG_DATA_HOME
if snap_data_home and snap_data_home:match("/snap/code/%d+/.local/share$") then
  vim.env.XDG_DATA_HOME = (vim.env.SNAP_REAL_HOME or vim.env.HOME) .. "/.local/share"
end

require("config.lazy")


