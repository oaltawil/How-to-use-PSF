# How-to-use-PSF

The Package Support Framework (PSF) is an open source kit that helps you apply fixes to your existing desktop application when you don't have access to the source code, so that it can run in an MSIX container. The Package Support Framework helps your application follow the best practices of the modern runtime environment.

Here are some common examples where you can find the Package Support Framework useful:

- Your app can't find some DLLs when launched. You may need to set your current working directory. You can learn about the required current working directory in the original shortcut before you converted to MSIX.
- The app writes into the install folder. You will typically see it by "Access Denied" errors in Process Monitor.
- Your app needs to pass parameters to the executable on launch. You can learn more how PSF can help by going here and learn more about the available configurations here.
