self: super: {
  vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions {
    scalameta.metals = self.vscode-utils.extensionFromVscodeMarketplace {
      name = "metals";
      publisher = "scalameta";
      version = "1.9.10";
      sha256 = "0v599yssvk358gxfxnyzzkyk0y5krsbp8n4rkp9wb2ncxqsqladr";
    };
    # any other overrides here
  };
}
