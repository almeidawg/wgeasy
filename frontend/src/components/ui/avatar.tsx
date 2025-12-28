import * as React from "react";

const baseClasses =
  "relative inline-flex h-10 w-10 shrink-0 items-center justify-center overflow-hidden rounded-full bg-[#E5E7EB] text-sm font-medium text-[#4B5563]";

const Avatar = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, children, ...props }, ref) => (
    <div ref={ref} className={`${baseClasses} ${className || ""}`} {...props}>
      {children}
    </div>
  )
);
Avatar.displayName = "Avatar";

const AvatarImage = React.forwardRef<HTMLImageElement, React.ImgHTMLAttributes<HTMLImageElement>>(
  ({ className, ...props }, ref) => (
    <img
      ref={ref}
      className={`h-full w-full object-cover transition-opacity duration-150 ease-in-out ${className || ""}`}
      {...props}
    />
  )
);
AvatarImage.displayName = "AvatarImage";

const AvatarFallback = React.forwardRef<HTMLSpanElement, React.HTMLAttributes<HTMLSpanElement>>(
  ({ className, ...props }, ref) => (
    <span
      ref={ref}
      className={`flex h-full w-full items-center justify-center bg-[#9CA3AF] text-white ${className || ""}`}
      {...props}
    />
  )
);
AvatarFallback.displayName = "AvatarFallback";

export { Avatar, AvatarFallback, AvatarImage };
