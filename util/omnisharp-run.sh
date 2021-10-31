#!/usr/bin/env bash
# Start Omnisharp C# language server with global mono install.
# This script is intended to be run be lsp-mode.

if [ -z "${LSP_MONO_BASE_DIR}" ]; then
    echo "LSP_MONO_BASE_DIR is not set!" 
    exit 1
fi

if [ -z "${LSP_OMNISHARP_EXE}" ]; then
    echo "LSP_OMNISHARP_EXE is not set!"
    exit 1
fi

base_dir="${LSP_MONO_BASE_DIR}"
bin_dir=${base_dir}/bin

mono_cmd=${bin_dir}/mono
omnisharp_cmd="${LSP_OMNISHARP_EXE}"

chmod 755 "${mono_cmd}"

# export mono_env_options="--assembly-loader=strict #--config ${config_file}"

"${mono_cmd}" "${omnisharp_cmd}" "$@"
