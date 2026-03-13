# OBA Logos Module

The **OBA (Ortus Branding Assets) Logos Module** provides a simple and consistent way to use official Ortus product logos inside ContentBox pages using a Markdown shortcode.

Instead of manually referencing image paths, developers and content editors can insert logos directly in their content using a familiar shortcode syntax.

Example:

```
{{logo product="boxlang"}}
```

This approach simplifies logo usage across ContentBox sites while ensuring consistency with official branding assets.

---

# Overview

The goal of the OBA module is to make it easy for developers and content editors to reference official Ortus product logos without needing to know file paths or manage assets manually.

By using a shortcode-based syntax, the module allows logos to be embedded directly within Markdown content while automatically resolving the correct SVG asset from the Ortus Branding Assets library.

This syntax is a **commonly used pattern across many CMS platforms** such as WordPress, Ghost, Hugo, and Shopify, making it intuitive and familiar for content authors.

---

# How It Works

The module integrates into the ContentBox rendering pipeline using ColdBox module architecture.

### 1. Module Initialization

The module is installed in a ColdBox / ContentBox application and loaded as a standard ColdBox module.

```
/modules/oba
```

When the application starts, the module registers its configuration and interceptors.

---

### 2. ColdBox Interceptor

The module registers a ColdBox interceptor that listens to the ContentBox rendering event:

```
cb_onContentRendering
```

This event is triggered whenever ContentBox renders page or content body data.

---

### 3. Shortcode Detection

When the interceptor runs, it inspects the page content and detects logo shortcodes such as:

```
{{logo product="boxlang"}}
```

---

### 4. Logo Resolution

The module resolves the correct SVG asset from the Ortus Branding Assets library located in:

```
/modules/oba/assets/logos/{product}/SVG/
```

---

### 5. HTML Rendering

The shortcode is replaced with the appropriate HTML element that renders the logo in the page.

Example output:

```html
<img src="/modules/oba/assets/logos/boxlang/SVG/boxlang-logo-full-dark-M.svg" alt="BoxLang logo">
```

---

# Shortcode Usage

The shortcode supports several optional attributes that allow developers to control how the logo is rendered.

### Basic Usage

```
{{logo product="boxlang"}}
```

Default configuration:

```
type = logo
variant = full
tone = dark
size = M
```

---

### Passing Attributes

Developers can override the default behavior using additional attributes.

Examples:

```
{{logo product="boxlang" type="icon"}}

{{logo product="boxlang" tone="light"}}

{{logo product="boxlang" variant="mono"}}
```

These attributes follow the asset naming convention:

```
{product}-{type}-{variant}-{tone}-{size}.svg
```

Example resolved file:

```
boxlang-icon-mono-dark-M.svg
```

---

### Adding CSS Classes

The shortcode also allows passing CSS classes to control layout or styling.

Example:

```
{{logo product="boxlang" class="w-48"}}
```

Result:

```html
<img src="/modules/oba/assets/logos/boxlang/SVG/boxlang-logo-full-dark-M.svg" class="w-48">
```

Example with multiple classes:

```
{{logo product="boxlang" class="w-40 mx-auto"}}
```

---

### Automatic Theme Switching

The module supports automatic dark/light theme switching.

Example:

```
{{logo product="boxlang" theme="auto"}}
```

When enabled, the module renders a `<picture>` element that switches logo variants depending on the user's system theme.

Example output:

```html
<picture>
  <source srcset="/modules/oba/assets/logos/boxlang/SVG/boxlang-logo-full-light-M.svg" media="(prefers-color-scheme: dark)">
  <img src="/modules/oba/assets/logos/boxlang/SVG/boxlang-logo-full-dark-M.svg" alt="BoxLang logo">
</picture>
```

This allows websites to support dark mode without requiring JavaScript.

---

# Module Structure

```
modules/oba
├── ModuleConfig.cfc
├── interceptors
│   └── LogoInterceptor.cfc
└── services
```

---

# Assets Structure

Logos are organized by product inside the assets directory.

```
assets/logos
├── boxlang
│   └── SVG
│       ├── boxlang-logo-full-dark-M.svg
│       ├── boxlang-logo-full-light-M.svg
│       └── boxlang-icon-mono-dark-M.svg
├── coldbox
│   └── SVG
└── commandbox
    └── SVG
```

---

# Current Status

| Area                                     | Status         | Notes                                                       |
| ---------------------------------------- | -------------- | ----------------------------------------------------------- |
| Module Structure                         | ✅ Completed    | ColdBox module created under `modules/oba`                  |
| Assets Organization                      | ✅ Completed    | Logos reorganized under `assets/logos/{product}/SVG`        |
| Module Configuration                     | ✅ Completed    | `ModuleConfig.cfc` registered and interceptor configured    |
| ColdBox Interceptor                      | ✅ Implemented  | `LogoInterceptor.cfc` listens to `cb_onContentRendering`    |
| Module Installation                      | 🔄 Testing     | Installing module from GitHub branch for development        |
| Interceptor Verification                 | 🔄 In Progress | Confirming interceptor triggers during ContentBox rendering |
| Shortcode Parser                         | ⏳ Pending      | Logic to detect and parse `{{logo ...}}` shortcodes         |
| Logo Resolver                            | ⏳ Pending      | Resolve correct logo file from asset structure              |
| HTML Output Rendering                    | ⏳ Pending      | Replace shortcode with `<img>` or `<picture>` output        |
| Package Distribution (`box install oba`) | ⏳ Future       | Requires `box.json` and ForgeBox publication                |
| Documentation                            | 🔄 In Progress | Architecture, usage, and examples being documented          |

---

# Future Plans

Planned improvements include:

* Publishing the module to **ForgeBox**
* Enabling installation via:

```
box install oba
```

* Expanding support for additional branding assets such as icons and other media
* Improving developer documentation and examples

---

# License

This project is part of the **Ortus Branding Assets** repository maintained by Ortus Solutions.
