INTERFACE /apmg/if_package_arg PUBLIC.

************************************************************************
* Package Arg
*
* Copyright (c) Marc Bernard <https://marcbernardtools.com/>
* SPDX-License-Identifier: MIT
************************************************************************
* Similar to npm-package-arg
* https://www.npmjs.com/package/npm-package-arg
************************************************************************

  CONSTANTS:
    c_version TYPE string VALUE '1.0.0'.

  TYPES:
    BEGIN OF ty_result,
      type         TYPE string,
      registry     TYPE string,
      name         TYPE string,
      scope        TYPE string,
      escaped_name TYPE string,
      raw          TYPE string,
    END OF ty_result.

ENDINTERFACE.
